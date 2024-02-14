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

  imports = [
    ./core
    ./plugins
  ];

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf cfg.useAsManPager {
      MANPAGER = "nvim +Man!";
    };

    programs.nixvim = {
      enable = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
    };
  };
}
