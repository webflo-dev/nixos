{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${vars.system}.default
  ];
}
