import { Audio } from "../../ags.js";
import { OSD, ProgressOSD } from "../../widgets/index.js";
import icons from "../../icons.js";

export const VolumeOSD = ({ anchor } = {}) => {
  return OSD({
    name: "osd-volume",
    anchor,
    connectionService: Audio,
    connectionServiceProps: "speaker-changed",
    child: ProgressOSD({
      anchor,
      connectionService: Audio,
      connectionServiceProps: "speaker-changed",
      update: () => {
        const volume = Audio.speaker?.volume;
        const isMuted = Audio.speaker?.stream.isMuted;

        return {
          value: volume,
          icon: isMuted ? icons.volume.muted : icons.volume.normal,
          toggleClassName: ["muted", isMuted],
        };
      },
    }),
  });
};

export const MicrophoneOSD = ({ anchor } = {}) => {
  return OSD({
    name: "osd-microphone",
    anchor,
    connectionService: Audio,
    connectionServiceProps: "microphone-changed",
    child: ProgressOSD({
      anchor,
      connectionService: Audio,
      connectionServiceProps: "microphone-changed",
      update: () => {
        const volume = Audio.microphone?.volume;
        const isMuted = Audio.microphone?.stream.isMuted;

        return {
          value: volume,
          icon: isMuted ? icons.microphone.muted : icons.microphone.normal,
          toggleClassName: ["muted", isMuted],
        };
      },
    }),
  });
};
