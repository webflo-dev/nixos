{
  config,
  lib,
  ...
}: let
  cfg = config.webflo.modules.bluetooth;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.bluetooth = {
    enable = mkEnableOption "Bluetooth module";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
