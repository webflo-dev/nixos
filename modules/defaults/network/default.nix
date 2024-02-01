{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.webflo.modules.network;
  inherit (lib) mkOption types;
in {
  options.webflo.modules.network = {
    hostName = mkOption {type = types.str;};
  };

  config = {
    networking = {
      inherit (cfg) hostName;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
