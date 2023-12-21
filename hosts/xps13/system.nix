{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ### Nixos modules
    ../../presets/network.nix
    ../../presets/network.nix
    ../../presets/security.nix
    ../../presets/nix-settings.nix

    ### Core modules
    ../../presets/locales.nix
    ../../presets/cli-tools.nix
    ../../presets/zsh.nix
    ../../presets/pipewire.nix
    ../../presets/agenix.nix

    ### Desktop modules
    ../../presets/fonts.nix
    ../../presets/hyprland.nix
    ../../presets/thunar.nix
    ../../presets/video.nix

    ### Host-specific modules
    ../../presets/bluetooth.nix
    ../../presets/fingerprint.nix

    ### Other modules
    ../../presets/work.nix
    ../../presets/development.nix
    ../../presets/docker.nix
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
  };

  environment.systemPackages = with pkgs; [
    eza
    udiskie
  ];

  system.stateVersion = "23.11";
}
