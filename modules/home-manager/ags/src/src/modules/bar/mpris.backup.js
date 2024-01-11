import { Widget, Mpris } from "../../ags.js";
import icons from "../../icons.js";
import { getIconName } from "../../utils.js";

// const PlayerButton = ({ player, items, onClick, prop, canProp, cantValue }) =>
//   Widget.Button({
//     child: Widget.Stack({
//       items,
//       binds: [["shown", player, prop, (p) => `${p}`]],
//     }),
//     onClicked: player[onClick].bind(player),
//     binds: [["visible", player, canProp, (c) => c !== cantValue]],
//   });

const Indicator = ({ player }) =>
  Widget.Box({
    spacing: 8,
    class_name: "active-player",
    children: [
      Widget.Icon({ class_name: "icon", size: 24 }),
      Widget.Icon({ class_name: "thumbnail", size: 24 }),
      Widget.Button({
        class_name: "previous icon",
        child: Widget.Label({ label: icons.mpris.backward }),
        onClicked: () => player.previous(),
      }),
      Widget.Button({
        class_name: "play-pause icon",
        child: Widget.Stack({
          items: [
            [
              "Playing",
              Widget.Label({
                class_name: "icon",
                label: icons.mpris.pause,
              }),
            ],
            [
              "Paused",
              Widget.Label({
                class_name: "icon",
                label: icons.mpris.play,
              }),
            ],
            [
              "Stopped",
              Widget.Label({
                class_name: "icon",
                label: icons.mpris.stop,
              }),
            ],
          ],
          binds: [["shown", player, "play-back-status"]],
        }),
        onClicked: () => player.playPause(),
      }),
      Widget.Button({
        class_name: "next icon",
        child: Widget.Label({ label: icons.mpris.forward }),
        onClicked: () => player.next(),
      }),
      Widget.Label({ class_name: "artist" }),
      Widget.Label({
        class_name: "title",
      }),
    ],
    connections: [
      [
        player,
        (box) => {
          if (box._name !== player.name) {
            const iconName = getIconName(player.name);
            box.children[0].icon = iconName ?? icons.mpris.fallback;
            // const searchableName = player.name.toLowerCase();
            // const app = Applications.list.find((app) => {
            //   const appName = app.name.toLowerCase();
            //   if (appName === searchableName) return true;
            //   return appName.includes(searchableName);
            // });
            // box.children[0].icon = app?.iconName ?? icons.mpris.fallback;
          }
          box._name = player.name;

          if (
            box.children[1].icon !== player.coverPath &&
            !!player.trackCoverUrl
          ) {
            box.children[1].icon = player.coverPath;
          }
          box.children[1].visible = !!player.trackCoverUrl;

          box.children[5].label = player.trackArtists.join(", ");
          box.children[6].label = player.trackTitle;
        },
      ],
    ],
  });

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
            box._player = null;
            return;
          }

          if (box._player === player) return;

          box._player = player;
          box.children = [Indicator({ player })];
        },
        "player-changed",
      ],
    ],
  });
