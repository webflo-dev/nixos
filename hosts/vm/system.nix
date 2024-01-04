{ config, pkgs, vars, ... }:

{
  fileSystems."/home/${vars.username}/${vars.sharefolder}" = {
    device = "/${vars.sharefolder}";
    fsType = "9p";
    options = [ "trans=virtio" ];
  };

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = true;
    };
  };

  services.fwupd.enable = true;

  webflo.modules.cliTools.enable = true;

  system.stateVersion = "23.11";
}
