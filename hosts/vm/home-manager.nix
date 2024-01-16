{ pkgs, ... }:
{
  webflo.modules = {
    git.enable = true;
    zsh.enable = true;
    ranger.enable = true;
  };

  home.packages = with pkgs; [
    # CLI
    croc
    ranger

    # Browser
    microsoft-edge
    google-chrome
    brave
    vivaldi

    # Multimedia
    spotify

    # Development
    vscode
  ];
}

