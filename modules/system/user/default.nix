{ config, pkgs, ... }:
let
  settings = config.webflo.settings;
in
{
  config = {
    users.users.${settings.user.name} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      uid = settings.user.uid;
    };
    programs.zsh.enable = true;
  };
}
