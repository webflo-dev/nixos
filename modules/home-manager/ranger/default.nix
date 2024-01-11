{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.modules.ranger;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.modules.ranger = {
    enable = mkEnableOption "ranger module";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ranger
    ];

    xdg.configFile."ranger/rc.conf".source = ./rc.conf;
  };
}
