{ pkgs, inputs, vars, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${vars.system}.default
  ];

  age.identityPaths = [
    "/home/${vars.username}/.ssh/agenix-vanta-conf"
  ];
}
