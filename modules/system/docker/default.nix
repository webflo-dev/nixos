{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.modules.docker;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.webflo.modules.docker = {
    enable = mkEnableOption "Docker module";
    dockerGroupMembers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        # storage-driver = "overlay2";
        features = { buildkit = true; };
        experimental = true;
        no-new-privileges = true;
      };
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
        dates = "weekly";
      };
    };

    users.groups."docker".members = cfg.dockerGroupMembers;

    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
