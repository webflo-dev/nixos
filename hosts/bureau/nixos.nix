{
  config,
  pkgs,
  hostUsers,
  ...
}: {
  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
  ];

  services.fwupd.enable = true;

  webflo.modules = {
    nvidia.enable = true;
    logitech.enableMouse = true;
    pipewire.enable = true;
    video.enable = true;
    fonts.enable = true;
    thunar.enable = true;
    hyprland.enable = true;
    development.enable = true;
    docker.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      udiskie
      mpv
      appimage-run
      niri
    ]
    ++ [
      slack
      _1password-gui
    ];
}
