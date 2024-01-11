{ config, lib, pkgs, ... }:
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
    webflo.modules = {
      ags.enable = true;
      fonts.enable = true;
      gtk.enable = true;
      hyprland.enable = true;
      kitty.enable = true;
      mimeApps.enable = true;
      neofetch.enable = true;
      ranger.enable = true;
      xdg.enable = true;
    };
  };
}
