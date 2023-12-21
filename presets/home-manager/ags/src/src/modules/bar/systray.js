import { Widget, SystemTray } from "../../ags.js";

const SysTrayItem = (item) =>
  Widget.Button({
    child: Widget.Icon({ binds: [["icon", item, "icon"]] }),
    binds: [["tooltip-markup", item, "tooltip-markup"]],
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

export const SysTray = () =>
  Widget.Box({
    class_name: "systray",
    binds: [["children", SystemTray, "items", (i) => i.map(SysTrayItem)]],

    // connections: [
    //   [
    //     SystemTray,
    //     (self) => {
    //       self.children = SystemTray.items.map((item) =>
    //         Widget.Button({
    //           child: Widget.Icon({ binds: [["icon", item, "icon"]] }),
    //           onPrimaryClick: (_, event) => item.activate(event),
    //           onSecondaryClick: (_, event) => item.openMenu(event),
    //           binds: [["tooltip-markup", item, "tooltip-markup"]],
    //         }),
    //       );
    //     },
    //   ],
    // ],
  });
