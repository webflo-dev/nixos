{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.user;
  inherit (lib) mkOption types;
in
{
  options.webflo.modules.user = {
    username = mkOption {
      type = types.str;
    };

    uid = mkOption {
      type = types.int;
    };
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      uid = cfg.uid;
    };
    programs.zsh.enable = true;
  };
}