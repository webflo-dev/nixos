import { App, Utils, Service } from "../ags.js";
import GLib from "gi://GLib";

const State = {
  idle: "idle",
  selecting_area: "selecting_area",
  recording: "recording",
};

function timeStamp() {
  return GLib.DateTime.new_now_local().format("%Y-%m-%d__%H-%M-%S");
}

function notify(file) {
  return Utils.execAsync([
    "notify-send",
    "-A",
    "copy-file=Copy path",
    "-A",
    "view=View",
    "-A",
    "delete=Delete",
    "-i",
    "record-desktop-indicator",
    "Screenrecord",
    file,
  ]).then((result) => {
    switch (result) {
      case "copy-file":
        Utils.execAsync(`wl-copy --type text/plain  ${file}`);
        break;
      case "view":
        Utils.execAsync(`mpv ${file}`);
        break;
      case "delete":
        Utils.execAsync(`rm ${file}`);
        break;
    }
  });
}

function startRecording(geometry, file) {
  return Utils.execAsync(["wf-recorder", "-g", `${geometry}`, "-f", file]);
}

function stopRecording() {
  return Utils.execAsync("killall -INT wf-recorder");
}

class ScreenrecordService extends Service {
  static {
    Service.register(
      this,
      {},
      {
        timer: ["int", "r"],
        state: ["string", "r"],
      },
    );
  }

  state = "idle";
  timer = 0;

  _file;

  _state(value) {
    this.state = value;
    this.notify("state");
  }

  start() {
    if (this.state !== State.idle) return;
    this._state(State.selecting_area);

    Utils.execAsync(`${App.configDir}/scripts/geometry.sh`).then((geometry) => {
      if (!geometry) {
        this._state(State.idle);
        return;
      }

      this._file = `${GLib.get_home_dir()}/Videos/Recordings/screenrecord__${timeStamp()}.mp4`;

      this._state(State.recording);

      startRecording(geometry, this._file).catch((err) => {
        console.error(err);
        this._state(State.idle);
      });

      this.timer = 0;
      this._interval = Utils.interval(1000, () => {
        this.notify("timer");
        this.timer++;
      });
    });
  }

  stop() {
    if (this.state === State.idle) return;

    stopRecording()
      .then(() => {
        this._state(State.idle);
        GLib.source_remove(this._interval);
        notify(this._file);
      })
      .catch((err) => {
        this._state(State.idle);
        console.error(err);
      });
  }

  toggle() {
    switch (this.state) {
      case State.idle:
        this.start();
        break;
      case State.recording:
        this.stop();
        break;
      default:
        this._state(State.idle);
        break;
    }
  }
}

export default new ScreenrecordService();
