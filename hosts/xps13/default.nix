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

  # webflo.settings = {
  #   user = {
  #     name = "florent";
  #     uid = 1000;
  #   };
  #   monitor = {
  #     name = "eDP-1";
  #     resolution = {
  #       width = 1920;
  #       height = 1200;
  #     };
  #     refreshRate = 60;
  #   };
  # };

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

    zsh.enable = true;

    cliTools.enable = true;

    desktop = {
      fonts.enable = true;
      thunar.enable = true;
      hyprland.enable = true;
    };

    development = {
      enable = true;
      inherit username;
    };

    docker.enable = true;
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
