import { App, Utils, Service } from "../ags.js";
import GLib from "gi://GLib";

function timeStamp() {
  return GLib.DateTime.new_now_local().format("%Y-%m-%d__%H-%M-%S");
}

function notify(file) {
  return Utils.execAsync([
    "notify-send",
    "-A",
    "copy-image=Copy image",
    "-A",
    "copy-file=Copy path",
    "-A",
    "view=View",
    "-A",
    "edit=Edit",
    "-A",
    "delete=Delete",
    "-i",
    file,
    "Screenshot",
    file,
  ]).then((res) => {
    switch (res) {
      case "copy-image":
        Utils.execAsync(`wl-copy --type image/png < ${file}`);
        break;
      case "copy-file":
        Utils.execAsync(`wl-copy --type text/plain  ${file}`);
        break;
      case "view":
        Utils.execAsync(`imv ${file}`);
        break;
      case "edit":
        Utils.execAsync(`swappy -f ${file}`);
        break;
      case "delete":
        Utils.execAsync(`rm ${file}`);
        break;
    }
  });
}

function takeScreenshot(geometry, file) {
  return Utils.execAsync(["grim", "-g", `${geometry}`, file]);
}

class ScreenshotService extends Service {
  static {
    Service.register(
      this,
      {},
      {
        busy: "boolean",
      },
    );
  }

  busy = false;

  _state(value) {
    this.busy = value;
    this.notify("busy");
  }

  screenshot() {
    if (this.busy === true) return;

    this._state(true);

    Utils.execAsync(`${App.configDir}/scripts/geometry.sh`).then((geometry) => {
      if (!geometry) {
        this._state(false);
        return;
      }

      const file = `${GLib.get_home_dir()}/Pictures/Screenshots/screenshot__${timeStamp()}.png`;
      takeScreenshot(geometry, file)
        .then(() => {
          this._state(false);
          notify(file);
        })
        .catch((err) => {
          this._state(false);
          console.error("screenshot : ", err);
        });
    });
  }
}

export default new ScreenshotService();
