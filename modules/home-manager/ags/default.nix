{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.ags;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.ags = {
    enable = mkEnableOption "AGS (Aylur's GTK Shell)";
  };

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ### Build
      sassc
      bun

      ### tools
      jq
      slurp
      wf-recorder
      wl-clipboard
      imv
      grim
      mpv
      swappy
      killall
    ];

    programs.ags = {
      enable = true;
      configDir = ./src;
    };
  };
}
