{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.logitech;
  inherit (lib) mkEnableOption mkIf mkOption types mkMerge;
in {
  options.webflo.modules.logitech = {
    enableMouse = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.enableMouse) {
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = false;
      environment.systemPackages = with pkgs; [
        solaar
      ];
    })
    {}
  ];
}
