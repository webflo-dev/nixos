import { App } from "./src/ags.js";
import { Bar } from "./src/modules/bar/index.js";
import { AppLauncher } from "./src/modules/app-launcher/index.js";
import { NotificationCenter } from "./src/modules/notifications/index.js";
import {
  ScreenshotService,
  ScreenrecordService,
} from "./src/services/index.js";

import { VolumeOSD, MicrophoneOSD } from "./src/modules/osd/index.js";
import { PowerMenu, togglePowerMenu } from "./src/modules/power-menu/index.js";

// Use for CLI calls
globalThis.ags = { App };
globalThis.powermenu = { toggle: togglePowerMenu };
globalThis.screenshot = ScreenshotService;
globalThis.screenrecord = ScreenrecordService;

// cssWatcher();

export default {
  style: App.configDir + "/style.css",
  maxStreamVolume: 1,
  cacheNotificationActions: true,
  notificationPopupTimeout: 3000,
  windows: [
    Bar(),
    AppLauncher(),
    NotificationCenter(),
    VolumeOSD({anchor: "right"}),
    MicrophoneOSD({anchor: "right"}),
    PowerMenu(),
  ].flat(),
};
