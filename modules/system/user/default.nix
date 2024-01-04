{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.user;
  inherit (lib) mkOption mkEnableOption types mkIf;
in
{
  options.webflo.modules.user = {
    enable = mkEnableOption;
    
    username = mkOption {
      type = types.str;
    };

    uid = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      uid = cfg.uid;
    };
  };
}