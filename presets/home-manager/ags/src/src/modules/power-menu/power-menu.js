import { App, Widget, Variable, Utils } from "../../ags.js";
import { BlockingWindow, FaIcon } from "../../widgets/index.js";
import icons from "../../icons.js";

const WINDOW_NAME_POWERMENU = "power-menu";
const WINDOW_NAME_CONFIRM = "power-menu-confirm";

const Actions = [
  {
    cmd: "loginctl terminate-session self",
    label: "Log Out",
    key: "logout",
    icon: icons.powerMenu.logout,
  },
  {
    cmd: "systemctl reboot",
    label: "Reboot",
    key: "reboot",
    icon: icons.powerMenu.reboot,
  },
  {
    cmd: "systemctl poweroff",
    label: "Shutdown",
    key: "shutdown",
    icon: icons.powerMenu.shutdown,
  },
];

const confirmInfo = Variable({
  label: "",
  cmd: "",
  icon: "",
  key: "",
});

function confirm(info) {
  confirmInfo.value = info;
  App.openWindow(WINDOW_NAME_CONFIRM);
}

export function toggle() {
  App.closeWindow(WINDOW_NAME_CONFIRM);
  App.toggleWindow(WINDOW_NAME_POWERMENU);
}

export const Confirm = () =>
  Widget.Window({
    name: WINDOW_NAME_CONFIRM,
    expand: true,
    visible: false,
    anchor: [],
    focusable: true,
    popup: true,
    child: Widget.Box({
      class_name: "confirmation",
      vertical: true,
      homogeneous: true,
      binds: [
        ["className", confirmInfo, "value", ({ key }) => `confirmation ${key}`],
      ],
      children: [
        Widget.Box({
          class_name: "title",
          vertical: false,
          vexpand: true,
          hpack: "center",
          children: [
            FaIcon({
              binds: [["label", confirmInfo, "value", ({ icon }) => icon]],
            }),
            Widget.Label({
              binds: [["label", confirmInfo, "value", ({ label }) => label]],
            }),
          ],
        }),
        Widget.Box({
          class_name: "buttons",
          vexpand: true,
          vpack: "end",
          homogeneous: true,
          children: [
            Widget.Button({
              class_name: "no",
              child: Widget.Label("No"),
              onClicked: () => App.closeWindow(WINDOW_NAME_CONFIRM),
            }),
            Widget.Button({
              class_name: "yes",
              child: Widget.Label("Yes"),
              onClicked: () => {
                Utils.exec(confirmInfo.value.cmd);
              },
            }),
          ],
        }),
      ],
    }),
  });

const Button = (info) =>
  Widget.Button({
    onClicked: () => {
      confirm(info);
    },
    vpack: "center",
    class_name: info.key,
    child: Widget.Box({
      spacing: 8,
      vertical: true,
      children: [FaIcon({ label: info.icon }), Widget.Label(info.label)],
    }),
  });

export const PowerMenu = () =>
  BlockingWindow(
    {
      name: WINDOW_NAME_POWERMENU,
      popup: true,
    },
    {
      vertical: false,
      homogeneous: true,
      class_name: "power-menu",
      children: Actions.map(Button),
    },
  );
