{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.presets.desktop;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.webflo.presets.desktop = {
    enable = mkEnableOption "Desktop preset with Hyprland";
    username = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    
    webflo.modules.pipewire = {
      enable = true;
      audioGroupMembers = [ cfg.username];
    };

    webflo.modules.video = {
      enable = true;
      videoGroupMembers = [ cfg.username];
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