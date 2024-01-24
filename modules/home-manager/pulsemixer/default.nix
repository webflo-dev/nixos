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

  config = let
    desktopItem = pkgs.makeDesktopItem {
      name = "pulsemixer";
      desktopName = "Pulsemixer";
      exec = "kitty --class floating_terminal --title pulsemixer ${pkgs.pulsemixer}/bin/pulsemixer";
      terminal = false;
    };
  in
    mkIf cfg.enable {
      xdg.configFile."pulsemixer.cfg".source = ./pulsemixer.cfg;

      home.packages = [desktopItem];
    };
}
