{ pkgs, vars, ... }:

{
  imports = [
    ### Core modules
    ../../../presets/system/zsh.nix

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

  zramSwap.enable = true;
  services.fwupd.enable = true;

  webflo.modules.bluetooth.enable = true;
  webflo.modules.fingerprint.enable = true;

  webflo.modules = {
    pipewire = {
      enable = true;
      audioGroupMembers = [ vars.username ];
    };
    cli.enable = true;
  };

  environment.systemPackages = with pkgs; [
    udiskie
  ];

  system.stateVersion = "23.11";
}
