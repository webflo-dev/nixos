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
    enable = mkEnableOption "AGS module";
  };

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.sassc
    ];

    programs.ags = {
      enable = true;
      configDir = ./src;
    };
  };
}
