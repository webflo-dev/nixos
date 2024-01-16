{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.presets.desktop;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.presets.work = {
    enable = mkEnableOption "work preset";
  };

  config = mkIf cfg.enable {

    webflo.modules.development = {
      enable = true;
    };

    webflo.modules.docker.enable = true;


    environment.systemPackages = with pkgs; [
      slack
      _1password-gui
      postgresql
      nodejs_20
      jq
      envsubst
    ];

    # webflo.modules.vanta-agent.enable = false;

  };
}
