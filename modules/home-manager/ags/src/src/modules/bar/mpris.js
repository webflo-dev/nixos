import { Widget, Mpris } from "../../ags.js";
import icons from "../../icons.js";
import { getIconName } from "../../utils.js";

const CurrentPlayer = (player) => {
  return Widget.Box({
    spacing: 8,
    class_name: "active-player",
    children: [
      Widget.Icon({ class_name: "icon", size: 24 }),
      Widget.Icon({ class_name: "thumbnail", size: 24 }),
      Widget.Label({ class_name: "artist" }),
      Widget.Label({ class_name: "title" }),
    ],
    connections: [
      [
        player,
        (box) => {
          if (box._name !== player.name) {
            const iconName = getIconName(player.name);
            box.children[0].icon = iconName ?? icons.mpris.fallback;
          }
          box._name = player.name;

          if (box.children[1].icon !== player.coverPath && !!player.coverPath) {
            box.children[1].icon = player.coverPath;
          }
          box.children[1].visible = !!player.coverPath;

          box.children[2].label = player.trackArtists.join(", ");
          box.children[3].label = player.trackTitle;
        },
      ],
    ],
  });
};

export const MprisModule = () =>
  Widget.Box({
    class_name: "mpris",
    connections: [
      [
        Mpris,
        (box, busName) => {
          const player = Mpris.getPlayer(busName);
          box.visible = !!player;
          if (!player) {
            box._busName = null;
            return;
          }

          if (box._busName === busName) return;

          box._busName = busName;
          box.children = [CurrentPlayer(player)];
        },
        "player-changed",
      ],
    ],
  });
