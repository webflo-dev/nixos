{ pkgs, ... }:
{
  webflo.presets.desktop.enable = true;
  webflo.modules = {
    git.enable = true;
    zsh.enable = true;
    pulsemixer.enable = true;
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

