{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ### Nixos modules
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
    # ../../presets/hyprland.nix
    # ../../presets/thunar.nix
    # ../../presets/video.nix

    ### Host-specific modules
    # ../../presets/bluetooth.nix
    # ../../presets/fingerprint.nix

    ### Other modules
    ../../presets/work.nix
    ../../presets/development.nix
    ../../presets/docker.nix
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
