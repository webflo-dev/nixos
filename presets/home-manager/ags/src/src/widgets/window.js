import { App, Widget } from "../ags.js";
import { CenteredBox } from "./centered-box.js";

export const PopupWindow = (
  { name, popup = true, focusable = true, anchor = [] },
  content,
) => {
  const _window = Widget.Window({
    name,
    popup,
    focusable,
    anchor,
    visible: false,
    child: content,
  });

  _window.connect("button-release-event", (emitter) => {
    const [x, y] = emitter.get_pointer();
    if (x === 0 && y === 0) {
      App.closeWindow(name);
    }
  });

  return _window;
};

export const BlockingWindow = ({ name, popup = false }, contentProps) =>
  Widget.Window({
    name,
    visible: false,
    popup,
    focusable: true,
    anchor: ["top", "left", "bottom", "right"],
    child: CenteredBox(contentProps),
  });
