{
  config,
  lib,
  pkgs,
  hostUsers,
  ...
}: let
  cfg = config.webflo.modules.video;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.webflo.modules.video = {
    enable = mkEnableOption "Video module";
  };

  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
        driSupport = true;
        # extraPackages = with pkgs; [
        #   intel-media-driver
        #   vaapiIntel
        #   vaapiVdpau
        #   libvdpau-va-gl
        # ];
        extraPackages = with pkgs; [
          libva
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };

    boot.kernelModules = ["v4l2loopback"];
    boot.extraModulePackages = with pkgs; [
      linuxPackages.v4l2loopback
    ];

    environment.systemPackages = with pkgs; [
      v4l-utils
    ];

    users.groups."video".members = builtins.attrNames hostUsers;
  };
}