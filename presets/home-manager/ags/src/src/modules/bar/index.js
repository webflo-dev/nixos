import { Widget } from "../../ags.js";
import { Date, Time } from "./date-time.js";
import { Workspaces } from "./workspaces.js";
import { SysTray } from "./systray.js";
import { SystemInfoModule } from "./system-info.js";
import { AudioModule } from "./audio.js";
import { MprisModule } from "./mpris.js";
import { NotificationIndicator } from "./notification-indicator.js";
import { ScreenrecordIndicator } from "./screenrecord.js";
import { ScreenshotIndicator } from "./screenshot.js";

const Left = () =>
  Widget.Box({
    class_name: "left",
    spacing: 8,
    children: [Workspaces(), MprisModule()],
  });

const Center = () =>
  Widget.Box({
    spacing: 8,
    class_name: "middle",
    children: [
      Date(),
      Time(),
      ScreenrecordIndicator(),
      ScreenshotIndicator(),
      NotificationIndicator(),
    ],
  });

const Right = () =>
  Widget.Box({
    class_name: "right",
    spacing: 8,
    children: [
      Widget.Box({ hexpand: true }),
      AudioModule(),
      SysTray(),
      SystemInfoModule(),
    ],
  });

export const Bar = ({ monitor = 0 } = {}) =>
  Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    exclusive: true,
    monitor,
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "bar",
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });
