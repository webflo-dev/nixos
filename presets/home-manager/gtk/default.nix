{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    gtk3
    gtk4
  ];

  gtk = {
    enable = true;

    font = {
      name = "system-ui";
      size = 10;
    };

    theme = {
      name = "Qogir-Dark";
      package = pkgs.qogir-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      size = 0;
      package = pkgs.gnome.adwaita-icon-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3 = {
      bookmarks = [
        "file://${config.home.homeDirectory}/Pictures/Screenshots"
        "file://${config.home.homeDirectory}/Videos/Recordings"
        "file://${config.home.homeDirectory}/Downloads"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
      };

    };
  };
}

