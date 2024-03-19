{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.docker;
  inherit (lib) mkEnableOption mkOption mkIf types mkMerge;
  nvidiaCfg = config.webflo.modules.nvidia;
in {
  options.webflo.modules.docker = {
    enable = mkEnableOption "Docker module";
    dockerGroupMembers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          # storage-driver = "overlay2";
          features = {buildkit = true;};
          experimental = true;
          no-new-privileges = true;
        };
        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };
      };

      users.groups."docker".members = cfg.dockerGroupMembers;

      environment.systemPackages = with pkgs; [
        docker
        docker-compose
      ];
    }

    (mkIf nvidiaCfg.enable {
      virtualisation.docker = {
        # deprecated, use cdi.dynamic.nvidia.enable
        enableNvidia = nvidiaCfg.enable;
      };

      virtualisation.containers = {
        enable = true;
        cdi.dynamic.nvidia.enable = nvidiaCfg.enable;
      };

      environment.systemPackages = with pkgs; [
        nvidia-container-toolkit
      ];
    })
  ]);
}
