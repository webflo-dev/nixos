{ pkgs, vars, ... }:
{
  networking = {
    hostName = vars.hostname;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

}
