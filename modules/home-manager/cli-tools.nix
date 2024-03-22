{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.cliTools;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.webflo.modules.cliTools = {
    enable = mkEnableOption "CLI tools";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        btop
        croc
        curl
        fd
        gdu
        ripgrep
        p7zip
      ];
    }

    {
      home.packages = [pkgs.bat];
      home.sessionVariables = {
        PAGER = "bat -p";
      };
      programs.zsh = {
        shellAliases = {
          view = "bat";
          cat = "bat -p";
          more = "bat -p";
        };
      };
    }

    {
      home.packages = [pkgs.eza];
      programs.zsh = {
        shellAliases = {
          ls = "eza -la -L 3 --git --group-directories-first --ignore-glob='node_modules|.git' --icons";
          la = "ls";
          l = "ls";
        };
      };
    }

    {
      home.packages = with pkgs; [
        tlrc
        navi
      ];
      programs.zsh = let
        naviCmd = "${config.home.profileDirectory}/bin/navi";
      in {
        initExtra = ''
          eval "$(${naviCmd} widget zsh)"
        '';
      };
    }
  ]);

  # programs.less = {
  #   enable = true;
  #   envVariables = {
  #     LESS = "--ignore-case --long-prompt --raw-control-chars --chop-long-lines --quiet";
  #     LESSHISTFILE = "/dev/null";
  #     LESS_TERMCAP_md = "\$'\\e[01;97m'";
  #     LESS_TERMCAP_so = "\$'\\e[00;47;30m'";
  #     LESS_TERMCAP_us = "\$'\\e[04;97m'";
  #     LESS_TERMCAP_me = "\$'\\e[0m'";
  #     LESS_TERMCAP_se = "\$'\\e[0m'";
  #     LESS_TERMCAP_ue = "\$'\\e[0m'";
  #   kk};
  # };
}
