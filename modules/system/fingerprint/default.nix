{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.fingerprint;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.modules.fingerprint = {
    enable = mkEnableOption "fingerprint module";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libfprint-2-tod1-goodix
    ];

    services.fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };
}