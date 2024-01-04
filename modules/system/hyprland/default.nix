{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.desktop.hyprland;
  inherit (lib) mkEnableOption mkIf types;
  nvidiaCfg = config.webflo.modules.nvidia;
in
{
  options.webflo.modules.desktop.hyprland = {
    enable = mkEnableOption "Hyprland module";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    
    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = nvidiaCfg.enable;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    services.pipewire.enable = true;

    environment.systemPackages = with pkgs; [
      grim
      imv
      kitty
      polkit_gnome
      slurp
      swappy
      swaybg
      swaylock
      wf-recorder
      wl-clipboard
      wlr-randr
      xdg-desktop-portal-hyprland
    ];

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
      SDL_VIDEODRIVER = "wayland";
    } // lib.mkIf nvidiaCfg.enable {
      ### Nvidia
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
