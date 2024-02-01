import { Utils, Widget, Hyprland } from "../../ags.js";
import icons from "../../icons.js";

const dispatch = (arg) => () =>
  Utils.execAsync(`hyprctl dispatch workspace ${arg}`);

const workspaces = [1, 2, 3, 4, 5].map((i) =>
  Widget.Button({
    class_name: "workspace",
    setup: (btn) => (btn.id = i),
    onClicked: dispatch(i),
    child: Widget.Label({
      label: icons["circle" + i],
      class_name: "indicator icon",
      vpack: "center",
    }),
    connections: [
      [
        Hyprland,
        (btn) => {
          btn.toggleClassName("active", Hyprland.active.workspace.id === i);
          btn.toggleClassName(
            "occupied",
            Hyprland.getWorkspace(i)?.windows > 0,
          );
        },
      ],
    ],
  }),
);

export const Workspaces = () =>
  Widget.Box({
    class_name: "workspaces",
    spacing: 12,
    children: workspaces,
  });
