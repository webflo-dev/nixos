{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.binaries;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.webflo.modules.binaries = {
    enable = mkEnableOption "Custom binaries";
  };

  config = let
    homeBinDir = ".local/bin";
  in mkIf cfg.enable {
    home.sessionPath = [
      "${config.home.homeDirectory}/${homeBinDir}"
    ];
    home.file.${homeBinDir}.source = ./src;
  };
}
