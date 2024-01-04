{ config, pkgs, vars, ... }:

{
  imports = [
    ### Core modules
    ../../../presets/system/cli-tools.nix
    ../../../presets/system/zsh.nix

    ### Desktop modules
    ../../../presets/system/fonts.nix
    # ../../../presets/system/hyprland.nix
    # ../../../presets/system/thunar.nix
    # ../../../presets/system/video.nix

    ### Other modules
    ../../../presets/system/work.nix
    ../../../presets/system/development.nix
    ../../../presets/system/docker.nix
  ];

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

  webflo.modules = {
    cli.enable = true;
  };


  system.stateVersion = "23.11";
}
