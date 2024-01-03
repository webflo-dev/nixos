{ config, pkgs, vars, ... }:
{
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

  users.groups."video".members = [ "${vars.username}" ];

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with pkgs; [ linuxPackages.v4l2loopback ];

  environment.systemPackages = with pkgs; [ v4l-utils ];
}
