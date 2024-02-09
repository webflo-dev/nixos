{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.neovim;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.webflo.modules.neovim = {
    enable = mkEnableOption "neovim";
    useAsManPager = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.sessionVariables = mkIf cfg.useAsManPager {
      MANPAGER = "nvim +Man!";
    };
  };
}
