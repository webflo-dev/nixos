{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.thunar;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.thunar = {
    enable = mkEnableOption "Thunar module";
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true;
  };
}
