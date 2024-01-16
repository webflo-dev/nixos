{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.neofetch;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.neofetch = {
    enable = mkEnableOption "neofetch module";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.neofetch
    ];

    xdg.configFile."neofetch/config.conf".source = ./config.conf;
  };
}
