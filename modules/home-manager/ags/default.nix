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
      ### tools
      slurp
      wf-recorder
      wl-clipboard
      grim
      satty
      # swappy
    ];

    programs = {
      imv.enable = true;
      jq.enable = true;
    };

    programs.ags = {
      enable = true;
      configDir = ./src;
    };
  };
}
