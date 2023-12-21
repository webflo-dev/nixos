{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ### Nixos modules
    ../../../presets/system/network.nix
    ../../../presets/system/security.nix
    ../../../presets/system/nix-settings.nix

    ### Core modules
    ../../../presets/system/locales.nix
    ../../../presets/system/cli-tools.nix
    ../../../presets/system/zsh.nix
    ../../../presets/system/pipewire.nix
    ../../../presets/system/agenix.nix

    ### Desktop modules
    ../../../presets/system/fonts.nix
    ../../../presets/system/hyprland.nix
    ../../../presets/system/thunar.nix
    ../../../presets/system/video.nix

    ### Host-specific modules
    ../../../presets/system/bluetooth.nix
    ../../../presets/system/fingerprint.nix

    ### Other modules
    ../../../presets/system/work.nix
    ../../../presets/system/development.nix
    ../../../presets/system/docker.nix
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

  zramSwap.enable = true;

  services.fwupd.enable = true;

  users.users.${vars.username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    uid = vars.userId;
  };

  environment.systemPackages = with pkgs; [
    eza
    udiskie
  ];

  system.stateVersion = "23.11";
}
