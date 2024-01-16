{
  config,
  pkgs,
  ...
}: let
  inherit (config.webflo) settings;
in {
  networking = {
    networkmanager.enable = true;
    inherit (settings) hostName;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
