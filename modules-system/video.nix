{ config, pkgs, username, ... }:
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

  users.groups."video".members = [ "${username}" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback # screen sharing
  ];
}
