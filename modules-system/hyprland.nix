{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.pipewire.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    kitty
    grim
    slurp
    swaybg
    swaylock
    swappy
    wf-recorder
    wl-clipboard
    wlr-randr
  ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
    SDL_VIDEODRIVER = "wayland";
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
}
