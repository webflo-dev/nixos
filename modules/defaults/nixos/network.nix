{
  config,
  pkgs,
  lib,
  hostName,
  ...
}: let
  cfg = config.webflo.modules.network;
  inherit (lib) mkOption types;
in {
  # options.webflo.modules.network = {
  #   hostName = mkOption {type = types.str;};
  # };

  config = {
    networking = {
      # inherit (cfg) hostName;
      inherit hostName;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
