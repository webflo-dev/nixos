{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
    _1password-gui
    postgresql
    nodejs_20
  ];

  webflo.services.vanta-agent.enable = false;

}
