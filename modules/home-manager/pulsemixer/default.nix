{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.pulsemixer;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.pulsemixer = {
    enable = mkEnableOption "pulsemixer module";
  };

  config = mkIf cfg.enable {
    xdg.configFile."pulsemixer.cfg".source = ./pulsemixer.cfg;
  };
}
