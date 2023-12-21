# vanta agent service
{ config, lib, pkgs, inputs, vars, ... }:
with lib;
let
  cfg = config.webflo.services.vanta-agent;
in
{
  options.webflo.services.vanta-agent = {
    enable = mkEnableOption "Vanta agent";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      inputs.webflo.packages.${vars.system}.vanta-agent
    ];

    age = {
      identityPaths = [
        "/home/${vars.username}/.ssh/agenix-vanta-conf"
      ];
      secrets."vanta-conf".file = ../../secrets/vanta-conf.age;
    };

    environment.etc."vanta.conf".source = config.age.secrets."vanta-conf".path;
  };
}
