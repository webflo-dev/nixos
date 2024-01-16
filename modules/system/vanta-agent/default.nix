# vanta agent service
{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: let
  cfg = config.webflo.modules.vanta-agent;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.webflo.modules.vanta-agent = {
    enable = mkEnableOption "Vanta agent";
    keyFileName = mkOption {
      type = types.str;
      default = "agenix-vanta-conf";
    };
    secretFileName = mkOption {
      type = types.str;
      default = "vanta-conf.age";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.webflo-pkgs.packages.${vars.system}.vanta-agent
    ];

    age = {
      identityPaths = [
        "/home/${vars.username}/.ssh/${cfg.keyFileName}"
      ];
      secrets."vanta-conf".file = ../../secrets/${cfg.secretFileName};
    };

    environment.etc."vanta.conf".source = config.age.secrets."vanta-conf".path;
  };
}
