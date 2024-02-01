import { Widget } from "../../ags.js";
import icons from "../../icons.js";
import { SystemInfoService } from "../../services/index.js";

const LEVEL = {
  normal: "normal",
  warning: "warning",
  critical: "critical",
};

function getLevel(value) {
  if (value >= 70 && value < 90) return LEVEL.warning;
  if (value >= 90) return LEVEL.critical;
  return LEVEL.normal;
}

function System(signalName, icon, transform) {
  return Widget.Box({
    spacing: 8,
    children: [
      !!icon &&
        Widget.Label({
          class_name: "icon",
          label: icon,
        }),
      Widget.Label({
        label: "---",
        class_name: "text monospace",
      }),
    ],
    connections: [
      [
        SystemInfoService,
        (self) => {
          const data = SystemInfoService[signalName];
          const value = transform(data);
          self.children[1].label = `${value.padStart(2, " ")}%`;
          self.className = getLevel(value);
        },
        `notify::${signalName}`,
      ],
    ],
  });
}

export const SystemInfoModule = () =>
  Widget.Box({
    class_name: "system-info",
    spacing: 24,
    children: [
      System("cpu", icons.cpu, ({ usage }) => usage),
      System("memory", icons.memory, ({ total, used }) =>
        Math.floor((used / total) * 100).toString(),
      ),
      System("gpu", icons.gpu, ({ usage }) => usage),
    ],
  });
