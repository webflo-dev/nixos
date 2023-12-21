{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ### Nixos modules
    ../../modules/system/network.nix
    ../../modules/system/security.nix
    ../../modules/system/nix-settings.nix

    ### Core modules
    ../../modules/system/locales.nix
    ../../modules/system/cli-tools.nix
    ../../modules/system/zsh.nix
    ../../modules/system/pipewire.nix

    ### Desktop modules
    # ../../modules/system/fonts.nix
    # ../../modules/system/hyprland.nix
    # ../../modules/system/thunar.nix
    # ../../modules/system/video.nix

    ### Host-specific modules
    # ../../modules/system/bluetooth.nix
    # ../../modules/system/fingerprint.nix

    ### Other modules
    ../../modules/system/work.nix
    ../../modules/system/development.nix
    ../../modules/system/docker.nix
  ];

  fileSystems."/home/${vars.username}/${vars.sharefolder}" = {
    device = "/${vars.sharefolder}";
    fsType = "9p";
    options = [ "trans=virtio" ];
  };


  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 2;
      grub = {
        enable = true;
        device = "/dev/vda";
        useOSProber = true;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.fwupd.enable = true;

  users.users.${vars.username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    eza
    udiskie
  ];

  system.stateVersion = "23.11";
}
