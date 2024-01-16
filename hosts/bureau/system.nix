{
  config,
  pkgs,
  ...
}: let
  inherit (config.webflo) settings;
  username = settings.user.name;
in {
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
  };

  webflo.modules = {
    development = {
      enable = true;
    };

    docker.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      udiskie
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
