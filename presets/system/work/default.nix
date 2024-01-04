{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.presets.desktop;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.webflo.presets.work = {
    enable = mkEnableOption "work preset";
    username = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {

    webflo.modules.development = {
      enable = true;
      username = cfg.username;
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
