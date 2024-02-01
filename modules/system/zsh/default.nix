{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.zsh;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.zsh = {
    enable = mkEnableOption "ZSH module";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };

    environment.pathsToLink = ["/share/zsh"];

    programs.fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };
}
