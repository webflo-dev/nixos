{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/cli-tools.nix
    ../../modules/system/development.nix
    ../../modules/system/docker.nix
    ../../modules/system/fingerprint.nix
    ../../modules/system/fonts.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/locales.nix
    ../../modules/system/network.nix
    ../../modules/system/nix-settings.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/security.nix
    ../../modules/system/thunar.nix
    ../../modules/system/video.nix
    ../../modules/system/zsh.nix
  ];

  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      timeout = 2;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
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
