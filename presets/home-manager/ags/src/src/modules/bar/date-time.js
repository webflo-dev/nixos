import { Widget } from "../../ags.js";
import icons from "../../icons.js";
import GLib from "gi://GLib";

const Base = ({ name, className, icon, ...props } = {}) =>
  Widget.Box({
    name,
    class_name: "module",
    spacing: 8,
    children: [
      !!icon &&
        Widget.Label({
          class_name: "icon",
          vpack: "baseline",
          label: icon,
        }),
      Widget.Label({
        class_name: className,
        vpack: "baseline",
        ...props,
      }),
    ],
  });

export const Date = () =>
  Base({
    name: "module-date",
    class_name: "date",
    icon: icons.calendar,
    connections: [
      [
        1000,
        (label) =>
          (label.label = GLib.DateTime.new_now_local().format("%H:%M")),
      ],
    ],
  });

export const Time = () =>
  Base({
    name: "module-time",
    class_name: "time",
    icon: icons.clock,
    label: GLib.DateTime.new_now_local().format("%A %d %B"),
  });

export const DateTime = () =>
  Widget.Box({
    spacing: 8,
    children: [Date(), Time()],
  });
