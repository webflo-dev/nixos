{ pkgs, inputs, vars, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  services.sshd.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${vars.system}.default
  ];
}
