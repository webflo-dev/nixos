{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.cliTools;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.cliTools = {
    enable = mkEnableOption "CLI tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
      btop
      croc
      curl
      eza
      fd
      gdu
      gitui
      ripgrep
      unzip
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
    };

    programs.less = {
      enable = true;
      envVariables = {
        LESS = "-i -M -R -S -z-4";
        LESSHISTFILE = "/dev/null";
        LESS_TERMCAP_md = "\$'\\e[01;97m";
        LESS_TERMCAP_so = "\$'\\e[00;47;30m";
        LESS_TERMCAP_us = "\$'\\e[04;97m";
        LESS_TERMCAP_me = "\$'\\e[0m";
        LESS_TERMCAP_se = "\$'\\e[0m";
        LESS_TERMCAP_ue = "\$'\\e[0m";
      };
    };

    environment.variables = {
      PAGER = "bat -p";
      MANPAGER = "nvim +Man!";
      WORDCHARS = "*?[]~=&;!#\$%^(){}<>";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
