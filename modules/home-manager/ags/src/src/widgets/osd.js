import { Widget, Utils } from "../ags.js";
import { FaIcon } from "./index.js";

const PROGRESS_OSD_DEFAULTS = {
  width: 50,
  height: 250,
};

export const OSD = ({
  name,
  anchor,
  connectionService,
  connectionServiceProps,
  shouldPopup,
  child,
} = {}) => {
  const delay = 2000;
  let _count = 0;

  return Widget.Window({
    name,
    class_name: "osd",
    layer: "overlay",
    anchor: anchor ? [anchor] : [],
    child,
    connections: [
      [
        connectionService,
        (self) => {
          const isVisible = shouldPopup ? shouldPopup() : true;
          if (isVisible) {
            self.visible = true;
            _count++;
            Utils.timeout(delay, () => {
              _count--;

              if (_count === 0) {
                self.visible = false;
              }
            });
          }
        },
        connectionServiceProps,
      ],
    ],
  });
};

export const ProgressOSD = ({
  anchor,
  connectionService,
  connectionServiceProps,
  update,
} = {}) => {
  const isAnchorRight = anchor === "right";

  const width = isAnchorRight
    ? PROGRESS_OSD_DEFAULTS.width
    : PROGRESS_OSD_DEFAULTS.height;
  const height = isAnchorRight
    ? PROGRESS_OSD_DEFAULTS.height
    : PROGRESS_OSD_DEFAULTS.width;

  const progressIcon = FaIcon({
    hpack: isAnchorRight ? "center" : "start",
    vpack: isAnchorRight ? "end" : "center",
  });

  const progressBar = Widget.Box({
    class_name: "progress-bar",
    hexpand: isAnchorRight,
    vexpand: !isAnchorRight,
    hpack: isAnchorRight ? "fill" : "start",
    vpack: isAnchorRight ? "end" : "fill",
  });

  return Widget.Box({
    vertical: isAnchorRight,
    class_name: `progress ${isAnchorRight ? "vertical" : "horizontal"}`,
    child: Widget.Overlay({
      child: progressBar,
      overlays: [progressIcon],
    }),
    css: `min-width: ${width}px; min-height: ${height}px;`,
    connections: [
      [
        connectionService,
        (box) => {
          const { value, icon, toggleClassName } = update();

          const progressBarValue = (isAnchorRight ? height : width) * value;
          progressBar.setCss(
            `min-${isAnchorRight ? "height" : "width"}: ${progressBarValue}px`,
          );

          progressIcon.label = icon;
          box.toggleClassName(toggleClassName[0], toggleClassName[1]);
        },
        connectionServiceProps,
      ],
    ],
  });
};
