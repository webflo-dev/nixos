{ pkgs, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  services.sshd.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."x86_64-linux".default
  ];
}
