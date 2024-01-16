{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.presets.desktop;
  inherit (lib) mkEnableOption mkIf;
  settings = config.webflo.settings;
in
{
  options.webflo.presets.desktop = {
    enable = mkEnableOption "Desktop preset with Hyprland";
  };

  config = mkIf cfg.enable {

    webflo.modules.pipewire = {
      enable = true;
      audioGroupMembers = [ settings.user.name ];
    };

    webflo.modules.video = {
      enable = true;
      videoGroupMembers = [ settings.user.name ];
    };

    webflo.modules.zsh.enable = true;

    webflo.modules.cliTools.enable = true;

    webflo.modules.desktop = {
      fonts.enable = true;
      thunar.enable = true;
      hyprland.enable = true;
    };
  };
}
