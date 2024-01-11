import { App, Widget, Notifications, Utils } from "../../ags.js";
import { FaIcon } from "../../widgets/index.js";
import icons from "../../icons.js";

const Summary = () =>
  Widget.Label({
    class_name: "summary",
    connections: [
      [
        Notifications,
        (label) => {
          label.label =
            Notifications.notifications[0]?.summary ??
            " ".repeat(label.label.length);
        },
        "notify::popups",
      ],
    ],
  });

const ListIcon = () =>
  FaIcon({
    label: Notifications.dnd
      ? icons.notifications.dnd
      : icons.notifications.indicator,
  });

const AppIcon = ({ appIcon, appEntry }) => {
  if (Utils.lookUpIcon(appIcon)) {
    return Widget.Icon({ class_name: "app-icon", icon: appIcon });
  }

  if (Utils.lookUpIcon(appEntry)) {
    return Widget.Icon({ class_name: "app-icon", icon: appEntry });
  }
};

const Indicator = () =>
  Widget.Box({
    connections: [
      [
        Notifications,
        (box) => {
          if (Notifications.popups.length > 0) {
            const lastPopup = Notifications.popups[0];
            const child = AppIcon(lastPopup) || ListIcon();
            box.children = [child];
          } else {
            box.children = [ListIcon()];
          }
        },
      ],
    ],
  });

export const NotificationIndicator = () =>
  Widget.Button({
    onClicked: () => {
      // App.toggleWindow("window-closer");
      App.toggleWindow("notification-center");
    },
    name: "notification-indicator",
    child: Widget.Box({
      children: [
        Indicator(),
        Widget.Revealer({
          revealChild: false,
          transitionDuration: 250,
          transition: "slide_right",
          child: Summary(),
          binds: [
            ["revealChild", Notifications, "popups", (p) => p.length > 0],
          ],
        }),
      ],
    }),
    connections: [
      [
        Notifications,
        (btn) =>
          btn.toggleClassName("full", Notifications.notifications.length > 0),
        "notify::notifications",
      ],
    ],
  });
