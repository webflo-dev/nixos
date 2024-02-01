{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.fonts;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.fonts = {
    enable = mkEnableOption "fonts module";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    xdg.dataFile."fonts/test.sh".source = ./test.sh;
  };
}
