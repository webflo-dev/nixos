import { Widget, Utils } from "../../ags.js";
import GLib from "gi://GLib";

const NotificationIcon = ({ appEntry, appIcon, image }) => {
  if (image) {
    return Widget.Box({
      vpack: "start",
      hexpand: false,
      class_name: "image",
      css: `background-image: url("${image}");`,
    });
  }

  let icon = "dialog-information-symbolic";
  if (Utils.lookUpIcon(appIcon)) icon = appIcon;

  if (Utils.lookUpIcon(appEntry)) icon = appEntry;

  return Widget.Box({
    vpack: "start",
    hexpand: false,
    class_name: "image",
    children: [
      Widget.Icon({
        icon,
        size: 58,
        hpack: "center",
        hexpand: true,
        vpack: "center",
        vexpand: true,
      }),
    ],
  });
};

const Content = (notification) =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "content",
      vexpand: false,
      children: [
        NotificationIcon(notification),
        Widget.Box({
          hexpand: true,
          vertical: true,
          children: [
            Widget.Box({
              spacing: 8,
              class_name: "toto",
              vpack: "baseline",
              children: [
                Widget.Label({
                  class_name: "title",
                  vpack: "baseline",
                  xalign: 0,
                  justification: "left",
                  hexpand: true,
                  maxWidthChars: 24,
                  truncate: "end",
                  wrap: true,
                  label: notification.summary,
                  useMarkup: true,
                  // useMarkup: notification.summary.startsWith("<"),
                }),
                Widget.Label({
                  class_name: "time",
                  vpack: "bottom",
                  label: GLib.DateTime.new_from_unix_local(
                    notification.time,
                  ).format("%H:%M"),
                }),
                Widget.Button({
                  // onHover: hover,
                  class_name: "close-button",
                  vpack: "baseline",
                  child: Widget.Icon("window-close-symbolic"),
                  onClicked: () => notification.close(),
                }),
              ],
            }),
            Widget.Label({
              class_name: "description",
              hexpand: true,
              useMarkup: true,
              xalign: 0,
              justification: "left",
              label: notification.body,
              wrap: true,
            }),
          ],
        }),
      ],
    }),
  });

const Actions = (notification) =>
  Widget.Box({
    class_name: "actions",
    children: notification.actions.map((action) =>
      Widget.Button({
        class_name: "action-button",
        onClicked: () => notification.invoke(action.id),
        hexpand: true,
        child: Widget.Label(action.label),
      }),
    ),
    binds: [
      ["visible", notification, "actions", (actions) => actions.length > 0],
    ],
  });

export const Notification = (n) =>
  Widget.Box({
    class_name: `notification ${n.urgency}`,
    vertical: true,
    children: [Content(n), Actions(n)],
  });
