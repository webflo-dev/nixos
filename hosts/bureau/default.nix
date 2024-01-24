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

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = false;

  # webflo.settings = {
  #   user = {
  #     name = "florent";
  #     uid = 1000;
  #   };
  #   monitor = {
  #     name = "DP-2";
  #     resolution = {
  #       width = 3840;
  #       height = 2160;
  #     };
  #     refreshRate = 144;
  #   };
  # };

  services.fwupd.enable = true;

  webflo.modules = {
    nvidia.enable = true;
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

      # Logitech
      solaar
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
