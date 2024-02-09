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
    }
    {
      home.packages = [pkgs.eza];
      programs.zsh = {
        shellAliases = {
          # ls='ls -l -h -v --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F --tabsize=0 --literal --show-control-chars --color=always --human-readable'
          # la='ls -a'
          ls = "eza -la -L 3 --git --group-directories-first --ignore-glob='node_modules|.git' --icons";
          la = "ls";
          l = "ls";
        };
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
