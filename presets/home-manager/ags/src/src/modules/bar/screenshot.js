import { Widget } from "../../ags.js";
import { ScreenshotService } from "../../services/index.js";
import { FaIcon } from "../../widgets/index.js";
import icons from "../../icons.js";

export const ScreenshotIndicator = () =>
  Widget.Box({
    name: "screenshot",
    spacing: 8,
    children: [
      FaIcon({
        label: icons.camera,
      }),
      Widget.Label({
        label: "taking screenshot...",
      }),
    ],
    binds: [["visible", ScreenshotService, "busy"]],
  });
