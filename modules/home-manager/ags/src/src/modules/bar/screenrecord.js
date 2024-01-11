import { Widget } from "../../ags.js";
import { ScreenrecordService } from "../../services/index.js";
import { FaIcon } from "../../widgets/index.js";
import icons from "../../icons.js";

function getDuration(elapsed_time) {
  const hours = Math.floor(elapsed_time / 3600);
  const minutes = Math.floor((elapsed_time - hours * 3600) / 60);
  const seconds = Math.floor(elapsed_time - hours * 3600 - minutes * 60);
  return hours === 0
    ? `${minutes.toString().padStart(2, "0")}:${seconds
        .toString()
        .padStart(2, "0")}`
    : `${hours.toString().padStart(2, "0")}:${minutes
        .toString()
        .padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
}

const SelectingArea = () =>
  Widget.Box({
    name: "screenrecord",
    class_name: "selecting",
    spacing: 8,
    children: [
      FaIcon({
        label: icons.video,
      }),
      Widget.Label({
        label: "selecting area...",
      }),
    ],
  });

const Recording = () =>
  Widget.Button({
    name: "screenrecord",
    class_name: "recording",
    onClicked: () => {
      ScreenrecordService.stop();
    },
    child: Widget.Box({
      spacing: 8,
      children: [
        FaIcon({
          label: icons.video,
        }),
        Widget.Label({
          binds: [["label", ScreenrecordService, "timer", getDuration]],
        }),
      ],
    }),
  });

export const ScreenrecordIndicator = () =>
  Widget.Stack({
    items: [
      ["idle", null],
      ["selecting_area", SelectingArea()],
      ["recording", Recording()],
    ],
    binds: [["shown", ScreenrecordService, "state"]],
  });
