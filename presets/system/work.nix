{ config, pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
    _1password-gui
    postgresql
    nodejs_20
  ];

  webflo.services.vanta-agent.enable = true;

}
