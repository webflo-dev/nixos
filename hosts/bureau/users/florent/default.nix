{pkgs, ...}: {
  home.stateVersion = "23.11";

  imports = [
    ../../users-settings.nix
  ];

  webflo.modules = {
    ags.enable = true;
    binaries.enable = true;
    cliTools.enable = true;
    fonts.enable = true;
    git.enable = true;
    gtk.enable = true;
    hyprland = {
      enable = true;
      defaultWallpaper = ./wallpapers/mountain-3840x2160.jpg;
    };
    kitty.enable = true;
    mimeApps.enable = true;
    neofetch.enable = true;
    neovim.enable = true;
    pulsemixer.enable = true;
    ranger.enable = true;
    starship.enable = true;
    vscode.enable = true;
    zsh.enable = true;
  };

  home.packages = with pkgs; [
    # CLI
    croc
    yazi

    # Browser
    microsoft-edge
    google-chrome
    brave
    vivaldi

    # Multimedia
    spotify
  ];
}
