import { App, Widget, Notifications } from "../../ags.js";
import { CenteredBox, FaIcon, PopupWindow } from "../../widgets/index.js";
import icons from "../../icons.js";

import { Notification } from "./notification.js";

const List = () =>
  Widget.Box({
    vertical: true,
    vexpand: true,
    class_name: "list",
    binds: [
      [
        "children",
        Notifications,
        "notifications",
        (n) => n.reverse().map((n) => Notification(n)),
      ],
    ],
  });

const EmptyList = () =>
  CenteredBox({
    class_name: "empty-list",
    children: [Widget.Label("No notifications")],
  });

const NotificationList = () =>
  Widget.Scrollable({
    class_name: "notifications-scrollable",
    vexpand: true,
    hscroll: "never",
    vscroll: "automatic",
    child: Widget.Stack({
      items: [
        ["empty", EmptyList()],
        ["list", List()],
      ],
      binds: [
        [
          "shown",
          Notifications,
          "notifications",
          (n) => (n.length > 0 ? "list" : "empty"),
        ],
      ],
    }),
  });

const ClearButton = () =>
  Widget.Button({
    onClicked: (btn) => {
      if (btn.sensitive) {
        Notifications.clear();
        App.closeWindow("notification-center");
      }
    },
    class_name: "clear-button",
    child: Widget.Box({
      spacing: 5,
      children: [
        Widget.Label({
          label: "Clear",
          vpack: "baseline",
        }),
        FaIcon({ label: icons.trash, vpack: "baseline" }),
      ],
    }),
  });

const DoNotDisturbSwitch = () =>
  Widget.Switch({
    class_name: "dnd",
    vpack: "baseline",
    connections: [
      [
        "notify::active",
        ({ active }) => {
          Notifications.dnd = active;
        },
      ],
    ],
  });

const Header = () =>
  Widget.Box({
    class_name: "header",
    spacing: 8,
    vpack: "baseline",
    children: [
      Widget.Label({
        label: "Do Not Disturb",
        vpack: "baseline",
      }),
      DoNotDisturbSwitch(),
      Widget.Box({ hexpand: true }),
      ClearButton(),
    ],
    connections: [
      [
        Notifications,
        (box) =>
          (box.children[3].visible = Notifications.notifications.length > 0),
        "notify::notifications",
      ],
    ],
  });

export const NotificationCenter = () =>
  PopupWindow(
    {
      name: "notification-center",
      anchor: ["top"],
    },
    Widget.Box({
      vertical: true,
      class_name: "notifications",
      children: [Header(), NotificationList()],
    }),
  );
