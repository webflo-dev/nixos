{ config, pkgs, vars, ... }:
{
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  users.groups."video".members = [ "${vars.username}" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback # screen sharing
  ];
}
