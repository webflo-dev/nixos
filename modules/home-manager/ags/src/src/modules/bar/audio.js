import { Audio, Widget } from "../../ags.js";
import icons from "../../icons.js";

const Volume = () =>
  Widget.Box({
    class_name: "volume",
    spacing: 8,
    children: [
      Widget.Label({
        label: icons.volume.normal,
        class_name: "icon",
      }),
      Widget.Label({
        label: "---",
        class_name: "text monospace",
      }),
    ],
    connections: [
      [
        Audio,
        (self) => {
          if (!Audio.speaker) return;
          const muted = Audio.speaker.stream.is_muted;
          const volume = Math.round(Audio.speaker.volume * 100);
          self.children[1].label = `${volume.toString().padStart(3, " ")}%`;

          if (muted) {
            self.toggleClassName("muted", true);
            self.children[0].label = icons.volume.muted;
          } else {
            self.toggleClassName("muted", false);
            self.children[0].label = icons.volume.normal;
          }
        },
        "speaker-changed",
      ],
    ],
  });

const Microphone = () =>
  Widget.Box({
    class_name: "microphone",
    children: [
      Widget.Label({
        label: icons.microphone.normal,
        class_name: "icon",
        connections: [
          [
            Audio,
            (self) => {
              const muted = Audio.microphone?.stream.is_muted;
              if (muted) {
                self.label = icons.microphone.muted;
                self.toggleClassName("muted", true);
              } else {
                self.label = icons.microphone.normal;
                self.toggleClassName("muted", false);
              }
            },
            "microphone-changed",
          ],
        ],
      }),
    ],
  });

export const AudioModule = () => {
  return Widget.Box({
    class_name: "audio",
    spacing: 12,
    children: [Microphone(), Volume()],
  });
};
