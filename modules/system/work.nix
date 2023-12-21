{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    slack
    _1password-gui
    postgresql
    nodejs_20
    inputs.webflo.packages.${vars.system}.vanta-agent
  ];



}
