 { config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.network;
  inherit (lib) mkOption types;
in
{
  options.webflo.modules.network = {
    hostName = mkOption {
      description = "Set the hostname";
      type = types.str;
    };
  };

  config = {
    networking = {
      networkmanager.enable = true;
      hostName = cfg.hostName;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}