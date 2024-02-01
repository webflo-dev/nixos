{pkgs, ...}: {
  home.stateVersion = "23.11";

  webflo.modules = {
    ags.enable = true;
    fonts.enable = true;
    git.enable = true;
    gtk.enable = true;
    hyprland = {
      enable = true;
      wallpaper = ./wallpapers/house_by_the_lake_drawing-wallpaper-1920x1200;
    };
    kitty.enable = true;
    mimeApps.enable = true;
    neofetch.enable = true;
    pulsemixer.enable = true;
    ranger.enable = true;
    xdg.enable = true;
    zsh.enable = true;
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