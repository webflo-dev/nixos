{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.pipewire;
  inherit (lib) mkEnableOption mkOption types mkIf;
in {
  options.webflo.modules.pipewire = {
    enable = mkEnableOption "Pipewire module";
    enableEchoCancellation = mkOption {
      type = types.bool;
      default = true;
    };
    enableNoiseCancellation = mkOption {
      type = types.bool;
      default = true;
    };
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
      # "pipewire/pipewire.conf.d/95-echo-cancellation.conf".text = mkIf cfg.enableEchoCancellation ''
      #    context.modules = [
      #     {
      #       name = libpipewire-module-echo-cancel
      #       args = {
      #         # library.name  = aec/libspa-aec-webrtc
      #         # node.latency = 1024/48000
      #         source.props = {
      #             node.name = "Echo Cancellation Source"
      #         }
      #         sink.props = {
      #             node.name = "Echo Cancellation Sink"
      #         }
      #       }
      #     }
      #   ]
      # '';
      # "pipewire/pipewire.conf.d/99-input-denoising.conf".text = mkIf cfg.enableNoiseCancellation ''
      #   context.modules = [
      #     {
      #       name = libpipewire-module-filter-chain
      #       args = {
      #         node.description = "Noise Canceling source"
      #         media.name = "Noise Canceling source"
      #         filter.graph = {
      #           nodes = [
      #             {
      #               type = ladspa
      #               name = rnnoise
      #               plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so;
      #               label = noise_suppressor_stereo
      #               control = {
      #                 "VAD Threshold (%)" 50.0
      #                 "VAD Grace Period (ms)" 150.0
      #                 "Retroactive VAD Grace (ms)" 0.0
      #               }
      #             }
      #           ]
      #         }
      #         audio.position = ["FL" "FR"]
      #         capture.props = {
      #           node.name = "effect_input.rnnoise"
      #           # node.name = "capture.rnnoise_source"
      #           node.passive = true
      #         }
      #         playback.props = {
      #           node.name = "effect_output.rnnoise"
      #           # node.name = "rnnoise_source"
      #           media.class = "Audio/Source"
      #           audio.arte = 48000
      #         }
      #       }
      #     }
      #   ]
      # '';
    };

    environment.systemPackages = with pkgs; [
      rnnoise-plugin
      pulseaudio
      pulseaudio-ctl
      pulsemixer
    ];
  };
}
