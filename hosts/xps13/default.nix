{
  config,
  pkgs,
  ...
}: let
  username = "florent";
in {
  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  services.fwupd.enable = true;

  webflo.modules = {
    bluetooth.enable = true;
    fingerprint.enable = true;

    pipewire = {
      enable = true;
      audioGroupMembers = [username];
    };

    video = {
      enable = true;
      videoGroupMembers = [username];
    };

    fonts.enable = true;
    thunar.enable = true;
    hyprland.enable = true;

    development = {
      enable = true;
      usernames = [username];
    };

    docker = {
      enable = true;
      dockerGroupMembers = [username];
    };
  };

  environment.systemPackages = with pkgs;
    [
      udiskie
      mpv
    ]
    ++ [
      slack
      _1password-gui
      postgresql
      nodejs_20
      jq
      envsubst
    ];
}
