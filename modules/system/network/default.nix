{ config, pkgs, ... }:
let
  settings = config.webflo.settings;
in
{
  networking = {
    networkmanager.enable = true;
    hostName = settings.hostName;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
