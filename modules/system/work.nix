{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
    _1password-gui
    postgresql
    nodejs_20
  ];



}
