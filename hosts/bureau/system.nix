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
    ../../../presets/system/nvidia.nix

    ### Other modules
    ../../../presets/system/work.nix
    ../../../presets/system/development.nix
    ../../../presets/system/docker.nix
  ];

  services.fwupd.enable = true;

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
