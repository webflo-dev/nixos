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
    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ./filetypes.nix
    ./color-scheme.nix

    ./plugins/treesitter.nix
    ./plugins/completion.nix
    ./plugins/lsp
    ./plugins/file-explorers.nix
  ];

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf cfg.useAsManPager {
      MANPAGER = "nvim +Man!";
    };

    programs.nixvim = {
      enable = true;

      globals.mapleader = " ";
      globals.maplocalleader = " ";
    };
  };
}
