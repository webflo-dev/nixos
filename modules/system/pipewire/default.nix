{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.pipewire;
  inherit (lib) mkEnableOption mkOption types mkIf;
in
{
  options.webflo.modules.pipewire = {
    enable = mkEnableOption "Pipewire module";
    audioGroupMembers = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    users.groups."audio".members = cfg.audioGroupMembers;


    environment.etc = {
      "pipewire/pipewire.conf.d/92-low-latency.conf".text = ''
        context.properties = {
          default.clock.rate = 44100
          default.clock.quantum = 512
          default.clock.min-quantum = 512
          default.clock.max-quantum = 512
        }
      '';
    };

    environment.systemPackages = with pkgs; [
      pulseaudio
      pulseaudio-ctl
      pulsemixer
    ];
  };
}