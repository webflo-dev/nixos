{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.gtk;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.gtk = {
    enable = mkEnableOption "gtk";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gtk3
      gtk4
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS-Monterey";
      size = 24;
    };

    gtk = {
      enable = true;

      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      font = {
        name = "system-ui";
        size = 10;
      };

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      cursorTheme = {
        name = "macOS-Monterey";
        size = 24;
        package = pkgs.apple-cursor;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      gtk3 = {
        bookmarks = [
          "file://${config.home.homeDirectory}/Pictures/screenshots"
          "file://${config.home.homeDirectory}/Videos/recording"
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
  };
}
