// src/config.ts
import {readFile} from "resource:///com/github/Aylur/ags/utils.js";
import GLib4 from "gi://GLib?version=2.0";

// src/modules/bar/date-time.ts
import GLib from "gi://GLib?version=2.0";

// src/icons.ts
var icons_default = {
  defaultApplication: "application-default-icon",
  ui: {
    check: "_check-symbolic",
    close: "window-close-symbolic"
  },
  microphone: {
    muted: "_microphone-slash-symbolic",
    unmuted: "_microphone-symbolic"
  },
  volume: {
    muted: "_volume-slash-symbolic",
    unmuted: "_volume-symbolic"
  },
  battery: {
    charging: "_battery-bolt-symbolic",
    empty: "_battery-empty-symbolic",
    low: "_battery-_-symbolic",
    quarter: "_battery-low-symbolic",
    half: "_battery-half-symbolic",
    threeQuarters: "_battery-three-quarters-symbolic",
    full: "_battery-full-symbolic"
  },
  powerProfiles: {
    performance: "_gauge-max-symbolic",
    powerSaver: "_gauge-min-symbolic",
    balanced: "_gauge-symbolic"
  },
  dateTime: {
    calendar: "_calendar-day-symbolic",
    clock: "_clock-symbolic"
  },
  notifications: {
    dnd: {
      enabled: "_dnd-symbolic",
      disabled: "_notification-symbolic"
    },
    clear: "_clear-notifications-symbolic"
  },
  systemInfo: {
    cpu: "_processor-symbolic",
    memory: "_memory-symbolic",
    gpu: "_gpu-symbolic"
  },
  workspace: {
    1: "_circle-1-symbolic",
    2: "_circle-2-symbolic",
    3: "_circle-3-symbolic",
    4: "_circle-4-symbolic",
    5: "_circle-5-symbolic"
  },
  powerMenu: {
    logout: "_logout-symbolic",
    reboot: "_reboot-symbolic",
    shutdown: "_power-off-symbolic"
  }
};

// src/modules/bar/date-time.ts
function DateTime() {
  return Widget.Box({
    name: "date-time",
    spacing: 8,
    child: Widget.Box({
      className: "date-time",
      spacing: 16,
      children: [
        Widget.Box({
          className: "date",
          spacing: 8,
          children: [Widget.Icon({ icon: icons_default.dateTime.calendar }), Date]
        }),
        Widget.Box({
          className: "time",
          spacing: 8,
          children: [Widget.Icon({ icon: icons_default.dateTime.clock }), Time]
        })
      ],
      setup: (self) => {
        self.poll(1000, () => {
          const now = GLib.DateTime.new_now_local();
          Date.label = now.format("%A %d %B") || "";
          Time.label = now.format("%H:%M") || "";
        });
      }
    })
  });
}
var Date = Widget.Label();
var Time = Widget.Label();

// node_modules/clsx/dist/clsx.mjs
var r = function(e) {
  var t, f, n = "";
  if (typeof e == "string" || typeof e == "number")
    n += e;
  else if (typeof e == "object")
    if (Array.isArray(e)) {
      var o = e.length;
      for (t = 0;t < o; t++)
        e[t] && (f = r(e[t])) && (n && (n += " "), n += f);
    } else
      for (f in e)
        e[f] && (n && (n += " "), n += f);
  return n;
};
function clsx() {
  for (var e, t, f = 0, n = "", o = arguments.length;f < o; f++)
    (e = arguments[f]) && (t = r(e)) && (n && (n += " "), n += t);
  return n;
}

// src/modules/bar/workspace.ts
function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id");
  return Widget.Box({
    name: "workspaces",
    spacing: 8,
    children: WorkspaceList.map((id) => Widget.Button({
      className: activeId.as((i) => clsx("workspace", {
        active: i === id,
        occupied: (hyprland.getWorkspace(id)?.windows || 0) > 0
      })),
      child: Widget.Icon({ icon: icons_default.workspace[id] }),
      onClicked: () => hyprland.messageAsync(`dispatch workspace ${id}`)
    }))
  });
}
var hyprland = await Service.import("hyprland");
var WorkspaceList = [1, 2, 3, 4, 5];

// src/services/script-service.ts
var parseScriptOutput = function(input) {
  const firstSeparator = input.indexOf(" ");
  const signal = input.substring(0, firstSeparator);
  const values = input.substring(firstSeparator + 1);
  const pairs = values.match(regex);
  const datum = {};
  if (pairs) {
    pairs.forEach((pair) => {
      const [key, value] = pair.split("=");
      datum[key] = value.replace(/"/g, "");
    });
  }
  return { signal, datum };
};
function watchScript(scriptName, convertOutput, processSignal) {
  const variable = Variable(undefined, {
    listen: [
      `${App.configDir}/scripts/${scriptName}`,
      (output) => {
        const values = parseScriptOutput(output);
        const value = convertOutput(values);
        processSignal(values.signal, value);
      }
    ]
  });
  return variable;
}
var regex = new RegExp(/(\w+=("[^"]*"|[^ ]*))/g);

class ScriptService extends Service {
  #var;
  constructor(scriptName) {
    super();
    this.#var = Variable(undefined, {
      listen: [
        `${App.configDir}/scripts/${scriptName}`,
        (output) => {
          const scriptOutput = parseScriptOutput(output);
          const value = this.convertOutput(scriptOutput);
          this.processSignal(scriptOutput.signal, value);
        }
      ]
    });
  }
  dispose() {
    this.#var.dispose();
  }
}

// src/services/audio/microphones.ts
class Microhpone extends Service {
  constructor() {
    super(...arguments);
  }
  static {
    Service.register(this, {}, {
      id: ["int"],
      name: ["string"],
      muted: ["boolean"],
      volume: ["int"],
      type: ["string"],
      default: ["boolean"]
    });
  }
  _id = -1;
  _name = "";
  _muted = false;
  _volume = -1;
  _type = "";
  _default = false;
  get id() {
    return this._id;
  }
  get name() {
    return this._name;
  }
  get muted() {
    return this._muted;
  }
  get volume() {
    return this._volume;
  }
  get type() {
    return this._type;
  }
  get default() {
    return this._default;
  }
  update(values) {
    ["id", "name", "muted", "volume", "type", "default"].forEach((prop) => {
      this.updateProperty(prop, values[prop]);
    });
    this.emit("changed");
  }
}

class Microphones extends Service {
  constructor() {
    super(...arguments);
  }
  static {
    Service.register(this, {
      "default-microphone-changed": ["jsobject"],
      "microphone-added": ["jsobject"]
    }, {
      microphone: ["jsobject", "r"],
      microphones: ["jsobject", "r"]
    });
  }
  _defaultMicrophone = new Microhpone;
  _microphones = new Map;
  get defaultMicrophone() {
    return this._defaultMicrophone;
  }
  get microphones() {
    return this._microphones;
  }
  process(value) {
    const newDefault = value.id !== this._defaultMicrophone.id;
    let microphoneAdded = false;
    if (!this._microphones.has(value.id)) {
      this._microphones.set(value.id, new Microhpone);
      microphoneAdded = true;
    }
    const microphone = this._microphones.get(value.id);
    if (microphone) {
      microphone.update(value);
    }
    if (value.default) {
      this._defaultMicrophone.update(value);
    }
    if (newDefault) {
      this.emit("default-microphone-changed", this._defaultMicrophone);
    }
    if (microphoneAdded) {
      this.emit("microphone-added", microphone);
    }
    this.emit("changed");
  }
}

// src/services/audio/speakers.ts
class Speaker extends Service {
  constructor() {
    super(...arguments);
  }
  static {
    Service.register(this, {}, {
      id: ["int"],
      name: ["string"],
      muted: ["boolean"],
      volume: ["int"],
      type: ["string"],
      default: ["boolean"]
    });
  }
  _id = -1;
  _name = "";
  _muted = false;
  _volume = -1;
  _type = "";
  _default = false;
  get id() {
    return this._id;
  }
  get name() {
    return this._name;
  }
  get muted() {
    return this._muted;
  }
  get volume() {
    return this._volume;
  }
  get type() {
    return this._type;
  }
  get default() {
    return this._default;
  }
  update(values) {
    ["id", "name", "muted", "volume", "type", "default"].forEach((prop) => {
      this.updateProperty(prop, values[prop]);
    });
    this.emit("changed");
  }
}

class Speakers extends Service {
  constructor() {
    super(...arguments);
  }
  static {
    Service.register(this, {
      "default-speaker-changed": ["jsobject"],
      "speaker-added": ["jsobject"]
    }, {
      speaker: ["jsobject", "r"],
      speakers: ["jsobject", "r"]
    });
  }
  _defaultSpeaker = new Speaker;
  _speakers = new Map;
  get defaultSpeaker() {
    return this._defaultSpeaker;
  }
  get speakers() {
    return this._speakers;
  }
  process(value) {
    const newDefault = value.id !== this._defaultSpeaker.id;
    let speakerAdded = false;
    if (!this._speakers.has(value.id)) {
      this._speakers.set(value.id, new Speaker);
      speakerAdded = true;
    }
    const speaker = this._speakers.get(value.id);
    if (speaker) {
      speaker.update(value);
    }
    if (value.default) {
      this._defaultSpeaker.update(value);
    }
    if (newDefault) {
      this.emit("default-speaker-changed", this._defaultSpeaker);
    }
    if (speakerAdded) {
      this.emit("speaker-added", speaker);
    }
    this.emit("changed");
  }
}

// src/services/audio/index.ts
var BooleanValues = {
  "1": true,
  "0": false,
  true: true,
  false: false,
  on: true,
  off: false
};

class AudioService extends ScriptService {
  constructor() {
    super(...arguments);
  }
  static {
    Service.register(this, {}, {
      speakers: ["jsobject", "r"],
      microphones: ["jsobject", "r"]
    });
  }
  _speakers = new Speakers;
  _microphones = new Microphones;
  get speakers() {
    return this._speakers;
  }
  get microphones() {
    return this._microphones;
  }
  convertOutput({ datum }) {
    return {
      id: Number(datum.id),
      name: datum.name,
      muted: BooleanValues[datum.muted] || false,
      volume: Number(datum.volume),
      type: datum.type,
      default: BooleanValues[datum.default] || false
    };
  }
  processSignal(signal, value) {
    switch (signal) {
      case "AUDIO::sink":
        this._speakers.process(value);
        break;
      case "AUDIO::source":
        this._microphones.process(value);
        break;
    }
  }
}
var Audio = new AudioService("audio.sh");
// src/services/system-info.ts
var parse = function(output) {
  switch (output.signal) {
    case "CPU":
      return {
        notifyProp: "cpu",
        value: { usage: Number(output.datum.usage) }
      };
    case "GPU":
      return {
        notifyProp: "gpu",
        value: { usage: Number(output.datum.usage) }
      };
    case "MEMORY":
      return {
        notifyProp: "memory",
        value: {
          total: Number(output.datum.total),
          free: Number(output.datum.free),
          used: Number(output.datum.used)
        }
      };
    default:
      return;
  }
};
var cpu = Variable({ usage: 0 });
var gpu = Variable({ usage: 0 });
var memory = Variable({ total: 0, free: 0, used: 0 });
watchScript("system.sh", parse, (signal, values) => {
  if (!values)
    return;
  const { notifyProp, value } = values;
  switch (notifyProp) {
    case "cpu":
      cpu.setValue(value);
      break;
    case "gpu":
      gpu.setValue(value);
      break;
    case "memory":
      memory.setValue(value);
      break;
  }
});
var SystemInfo = {
  cpu,
  gpu,
  memory
};
// src/modules/bar/system-info.ts
var getLevel = function(value) {
  const current = Number(value);
  return levels.find(({ thresold }) => current >= thresold)?.value;
};
var SystemModule = function(icon, binding) {
  return Widget.Box({
    spacing: 8,
    className: binding.as((v) => {
      return clsx("info", getLevel(v));
    }),
    children: [
      Widget.Icon({ icon }),
      Widget.Label({
        label: binding.as((v) => `${v.padStart(2, " ")}%`)
      })
    ]
  });
};
function SystemInfo2() {
  return Widget.Box({
    name: "system-info",
    spacing: 24,
    children: [
      SystemModule(icons_default.systemInfo.cpu, SystemInfo.cpu.bind().as(({ usage }) => `${usage}`)),
      SystemModule(icons_default.systemInfo.memory, SystemInfo.memory.bind().as(({ used, total }) => Math.floor(used / total * 100).toString())),
      SystemModule(icons_default.systemInfo.gpu, SystemInfo.gpu.bind().as(({ usage }) => `${usage}`))
    ]
  });
}
var levels = [
  { thresold: 90, value: "critical" },
  { thresold: 70, value: "warning" }
];

// src/modules/bar/systray.ts
import Gdk2 from "gi://Gdk";
var systemtray = await Service.import("systemtray");
var SysTrayItem = (item) => Widget.Button({
  className: "systray-item",
  child: Widget.Icon({ icon: item.bind("icon") }),
  tooltipMarkup: item.bind("tooltip_markup"),
  onPrimaryClick: (btn) => item.menu?.popup_at_widget(btn, Gdk2.Gravity.SOUTH, Gdk2.Gravity.NORTH, null),
  onSecondaryClick: (btn) => item.menu?.popup_at_widget(btn, Gdk2.Gravity.SOUTH, Gdk2.Gravity.NORTH, null)
});
var Systray = () => Widget.Box({
  name: "systray",
  spacing: 16
}).bind("children", systemtray, "items", (i) => i.map(SysTrayItem));

// src/modules/bar/audio.ts
var Microphone = function() {
  return Widget.EventBox({
    onPrimaryClick: () => {
      Utils.execAsync("volume --toggle-mic");
    },
    tooltip_markup: Audio.microphones.defaultMicrophone.bind("name"),
    child: Widget.Box({
      className: Audio.microphones.defaultMicrophone.bind("muted").as((muted) => `microphone ${clsx({ muted })}`),
      spacing: 8,
      children: [
        Widget.Icon({
          icon: Audio.microphones.defaultMicrophone.bind("muted").as((muted) => muted ? icons_default.microphone.muted : icons_default.microphone.unmuted)
        })
      ]
    })
  });
};
var Volume = function() {
  return Widget.EventBox({
    onPrimaryClick: () => {
      Utils.execAsync("volume --toggle");
    },
    tooltip_markup: Audio.speakers.defaultSpeaker.bind("name"),
    child: Widget.Box({
      className: Audio.speakers.defaultSpeaker.bind("muted").as((muted) => `volume ${clsx({ muted })}`),
      spacing: 8,
      children: [
        Widget.Icon({
          icon: Audio.speakers.defaultSpeaker.bind("muted").as((muted) => muted ? icons_default.volume.muted : icons_default.volume.unmuted)
        }),
        Widget.Label({
          label: Audio.speakers.defaultSpeaker.bind("volume").as((volume) => `${volume.toString().padStart(3, " ")}%`)
        })
      ]
    })
  });
};
var Audio2 = () => Widget.Box({
  name: "audio",
  spacing: 12,
  children: [Microphone(), Volume()]
});

// src/modules/bar/notification-indicator.ts
var AppIcon = function({ app_icon, app_entry }) {
  if (Utils.lookUpIcon(app_icon))
    return app_icon;
  if (Utils.lookUpIcon(app_entry))
    return app_entry;
};
function NotificationIndicator() {
  const _dnd = notifications.bind("dnd");
  const _notifications = notifications.bind("notifications");
  const messageIcon = Widget.Icon();
  const messageLabel = Widget.Label();
  return Widget.Box({
    name: "notification-indicator",
    className: Utils.merge([_dnd, _notifications], (dnd, notifications) => clsx({
      dnd,
      empty: notifications.length === 0
    })),
    children: [
      Widget.Button({
        child: Widget.Box({
          children: [
            Widget.Icon({
              icon: _dnd.as((dnd) => dnd ? icons_default.notifications.dnd.enabled : icons_default.notifications.dnd.disabled)
            }),
            Widget.Revealer({
              transitionDuration: 500,
              transition: "slide_left",
              child: Widget.Box({
                spacing: 8,
                marginLeft: 8,
                children: [messageIcon, messageLabel]
              })
            }).hook(notifications, (revealer) => {
              if (notifications.popups.length > 0) {
                revealer.revealChild = true;
                const popup = notifications.popups[0];
                messageLabel.label = popup.summary;
                const icon = AppIcon(popup);
                if (icon) {
                  messageIcon.visible = true;
                  messageIcon.icon = icon;
                } else {
                  messageIcon.visible = false;
                }
              } else {
                revealer.revealChild = false;
              }
            }, "notify::popups")
          ]
        }),
        onClicked: () => {
          App.toggleWindow("notification-center");
        },
        onSecondaryClick: () => {
          notifications.dnd = !notifications.dnd;
        }
      })
    ]
  });
}
var notifications = await Service.import("notifications");

// src/modules/bar/battery.ts
var getLevel2 = function(value) {
  if (value < 5)
    return { key: "empty", icon: icons_default.battery.empty };
  if (value < 10)
    return { key: "low", icon: icons_default.battery.low };
  if (value < 25)
    return { key: "quarter", icon: icons_default.battery.quarter };
  if (value < 50)
    return { key: "half", icon: icons_default.battery.half };
  if (value < 75)
    return { key: "three-quarters", icon: icons_default.battery.threeQuarters };
  return { key: "full", icon: icons_default.battery.full };
};
var BatteryIcon = function() {
  return Widget.Icon().hook(battery, (widget) => {
    if (battery.charging || battery.charged) {
      widget.icon = icons_default.battery.charging;
    } else {
      widget.icon = getLevel2(battery.percent).icon;
    }
  });
};
var PowerProfile = function() {
  const menu = Widget.Menu({
    children: powerProfiles.bind("profiles").as((profiles) => {
      return profiles.map((profile) => {
        return Widget.MenuItem({
          onActivate: () => {
            powerProfiles.active_profile = profile.Profile;
          },
          child: Widget.Box({
            spacing: 8,
            children: [
              Widget.Icon({
                icon: powerProfiles.bind("active_profile").as((activeProfile) => {
                  return profile.Profile === activeProfile ? icons_default.ui.check : "";
                })
              }),
              Widget.Label({
                label: profile.Profile
              })
            ]
          })
        });
      });
    })
  });
  return Widget.EventBox({
    onSecondaryClick: (_, event) => {
      menu.popup_at_pointer(event);
    },
    child: Widget.Icon({
      icon: powerProfiles.bind("active_profile").as((profile) => icons_default.powerProfiles[profile] || "")
    })
  });
};
function Battery() {
  return Widget.Box({
    name: "battery",
    className: Utils.watch("", battery, () => {
      const charging = battery.charging || battery.charged;
      return clsx({
        charging,
        [getLevel2(battery.percent).key]: !charging
      });
    }),
    visible: battery.bind("available"),
    spacing: 8,
    children: [
      Widget.Box({
        className: "battery",
        spacing: 8,
        children: [
          PowerProfile(),
          BatteryIcon(),
          Widget.Label({
            label: battery.bind("percent").as((percent) => `${percent}%`)
          })
        ]
      })
    ]
  });
}
var battery = await Service.import("battery");
var powerProfiles = await Service.import("powerprofiles");

// src/modules/bar/index.ts
var StartWidget = () => Widget.Box({
  className: "left",
  spacing: 8,
  children: [Workspaces()]
});
var CenterWidget = () => Widget.Box({
  spacing: 8,
  className: "middle",
  hpack: "center",
  children: [
    DateTime()
  ]
});
var EndWidget = () => Widget.Box({
  className: "right",
  spacing: 8,
  children: [
    NotificationIndicator(),
    Widget.Box({
      hpack: "end",
      hexpand: true,
      spacing: 8,
      children: [Systray(), Audio2(), SystemInfo2(), Battery()]
    })
  ]
});
var TopBar = () => Widget.Window({
  name: "bar",
  className: "bar",
  exclusivity: "exclusive",
  anchor: ["top", "left", "right"],
  margins: [5, 20, 0, 20],
  child: Widget.CenterBox({
    spacing: 8,
    startWidget: StartWidget(),
    centerWidget: CenterWidget(),
    endWidget: EndWidget()
  })
});

// src/widgets/padding.ts
var Padding = (name, { css = "", hexpand = true, vexpand = true } = {}) => Widget.EventBox({
  hexpand,
  vexpand,
  can_focus: false,
  child: Widget.Box({ css }),
  setup: (w) => w.on("button-press-event", () => App.toggleWindow(name))
});

// src/widgets/popup-window.ts
function PopupWindow({
  name,
  child,
  layout = "center",
  exclusivity = "ignore",
  ...props
}) {
  return Widget.Window({
    name,
    class_names: [name, "popup-window"],
    setup: (w) => w.keybind("Escape", () => App.closeWindow(name)),
    visible: false,
    keymode: "on-demand",
    exclusivity,
    layer: "top",
    anchor: ["top", "bottom", "right", "left"],
    child: Layout(name, Widget.Box({ child }))[layout](),
    ...props
  });
}
var Layout = (name, child) => ({
  center: () => Widget.CenterBox({}, Padding(name), Widget.CenterBox({ vertical: true }, Padding(name), child, Padding(name)), Padding(name)),
  top: () => Widget.CenterBox({}, Padding(name), Widget.Box({ vertical: true }, child, Padding(name)), Padding(name)),
  "top-right": () => Widget.Box({}, Padding(name), Widget.Box({
    hexpand: false,
    vertical: true
  }, child, Padding(name))),
  "top-center": () => Widget.Box({}, Padding(name), Widget.Box({
    hexpand: false,
    vertical: true
  }, child, Padding(name)), Padding(name)),
  "top-left": () => Widget.Box({}, Widget.Box({
    hexpand: false,
    vertical: true
  }, child, Padding(name)), Padding(name)),
  "bottom-left": () => Widget.Box({}, Widget.Box({
    hexpand: false,
    vertical: true
  }, Padding(name), child), Padding(name)),
  "bottom-center": () => Widget.Box({}, Padding(name), Widget.Box({
    hexpand: false,
    vertical: true
  }, Padding(name), child), Padding(name)),
  "bottom-right": () => Widget.Box({}, Padding(name), Widget.Box({
    hexpand: false,
    vertical: true
  }, Padding(name), child))
});
// src/modules/app-launcher/index.ts
var { query } = await Service.import("applications");
var WINDOW_NAME = "app-launcher";
var AppItem = (app) => Widget.Button({
  onClicked: () => {
    App.closeWindow(WINDOW_NAME);
    app.launch();
  },
  attribute: { app },
  className: "app-item",
  child: Widget.Box({
    children: [
      Widget.Icon({
        className: "icon",
        icon: app.icon_name || icons_default.defaultApplication
      }),
      Widget.Label({
        className: "title",
        label: app.name,
        xalign: 0,
        vpack: "center",
        truncate: "end"
      })
    ]
  })
});
var _Applauncher = () => {
  let applications = query("").map(AppItem);
  const list = Widget.Box({
    vertical: true,
    children: applications
  });
  function repopulate() {
    applications = query("").map(AppItem);
    list.children = applications;
  }
  const entry = Widget.Entry({
    hexpand: true,
    className: "entry",
    onAccept: () => {
      if (applications[0]) {
        App.toggleWindow(WINDOW_NAME);
        applications[0].attribute.app.launch();
      }
    },
    onChange: ({ text }) => applications.forEach((item) => {
      item.visible = item.attribute.app.match(text ?? "");
    })
  });
  return Widget.Box({
    vertical: true,
    className: "app-launcher",
    children: [
      entry,
      Widget.Scrollable({
        hscroll: "never",
        className: "list-container",
        child: list
      })
    ],
    setup: (self) => self.hook(App, (_, windowName, visible) => {
      if (windowName !== WINDOW_NAME)
        return;
      if (visible) {
        repopulate();
        entry.text = "";
        entry.grab_focus();
      }
    })
  });
};
var AppLauncher = () => {
  return PopupWindow({
    name: WINDOW_NAME,
    layout: "center",
    child: _Applauncher()
  });
};

// src/modules/power-menu/index.ts
var CenteredBox = function(props) {
  return Widget.Box({
    vpack: "center",
    hpack: "center",
    ...props
  });
};
var ActionButton = function({ action, onClicked }) {
  return Widget.Button({
    onClicked: () => {
      actionToConfirm.value = action;
      onClicked();
    },
    attribute: action.key,
    className: action.key,
    child: Widget.Box({
      spacing: 8,
      vertical: true,
      vpack: "center",
      children: [
        Widget.Icon({ icon: action.icon }),
        Widget.Label(action.label)
      ]
    })
  });
};
var PowerMenuConfirm = function({ onCancel, onConfirm }) {
  const cancelBtn = Widget.Button({
    className: "cancel",
    label: "No",
    onClicked: onCancel
  });
  const menu = Widget.Box({
    className: actionToConfirm.bind("value").as((v) => `${v?.key}`),
    vertical: true,
    children: [
      Widget.Box({
        className: "title",
        hpack: "center",
        spacing: 16,
        children: [
          Widget.Icon({
            icon: actionToConfirm.bind("value").as((v) => v?.icon || "")
          }),
          Widget.Label({
            label: actionToConfirm.bind("value").as((v) => v?.label || "---")
          })
        ]
      }),
      Widget.Box({
        className: "buttons",
        vexpand: true,
        vpack: "end",
        homogeneous: true,
        children: [
          cancelBtn,
          Widget.Button({
            className: "confirm",
            label: "Yes",
            onClicked: () => {
              if (actionToConfirm.value) {
                onConfirm(actionToConfirm.value);
              }
            }
          })
        ]
      })
    ]
  });
  return Object.assign(menu, {
    onShown: () => {
      cancelBtn.grab_focus();
    }
  });
};
function PowerMenu() {
  const actionButtons = Actions.map((action) => ActionButton({
    action,
    onClicked: () => {
      stack.shown = "confirmation";
    }
  }));
  const confirmMenu = PowerMenuConfirm({
    onCancel: () => {
      stack.shown = "selection";
    },
    onConfirm: (action) => {
      Utils.exec(action.cmd);
    }
  });
  const stack = Widget.Stack({
    children: {
      selection: CenteredBox({
        homogeneous: true,
        classNames: ["power-menu", "selection"],
        children: actionButtons
      }),
      confirmation: CenteredBox({
        homogeneous: true,
        classNames: ["power-menu", "confirmation"],
        child: confirmMenu
      })
    }
  }).on("notify::shown", (_) => {
    switch (_.shown) {
      case "selection":
        actionButtons.find((btn) => btn.attribute === "logout")?.grab_focus();
        break;
      case "confirmation":
        confirmMenu.onShown();
        break;
    }
  });
  return Widget.Window({
    name: WINDOW_NAME2,
    visible: false,
    keymode: "exclusive",
    anchor: ["top", "left", "bottom", "right"],
    exclusivity: "ignore",
    child: stack,
    setup: (self) => {
      self.hook(App, (_, windowName, visible) => {
        if (windowName === WINDOW_NAME2 && visible) {
          stack.shown = "selection";
        }
      }, "window-toggled");
    }
  }).keybind("Escape", () => App.closeWindow(WINDOW_NAME2));
}
function togglePowerMenu() {
  App.toggleWindow(WINDOW_NAME2);
}
var WINDOW_NAME2 = "power-menu";
var Actions = [
  {
    cmd: "loginctl terminate-session self",
    label: "Log Out",
    key: "logout",
    icon: icons_default.powerMenu.logout
  },
  {
    cmd: "systemctl reboot",
    label: "Reboot",
    key: "reboot",
    icon: icons_default.powerMenu.reboot
  },
  {
    cmd: "systemctl poweroff",
    label: "Shutdown",
    key: "shutdown",
    icon: icons_default.powerMenu.shutdown
  }
];
var actionToConfirm = Variable(undefined);

// src/modules/osd/progress.ts
function Progress({
  height = 50,
  width = 250,
  vertical = true
}) {
  const fill = Widget.Box({
    className: "fill",
    hexpand: vertical,
    vexpand: !vertical,
    hpack: vertical ? "fill" : "start",
    vpack: vertical ? "end" : "fill"
  });
  const container = Widget.Box({
    child: fill,
    css: `min-width: ${width}px; min-height: ${height}px;`
  });
  return Object.assign(container, {
    setValue: (value) => {
      if (value < 0)
        return "";
      const axis = vertical ? "height" : "width";
      const axisv = vertical ? height : width;
      const current_fill = axisv * value / 100;
      fill.css = `min-${axis}: ${current_fill}px;`;
    }
  });
}

// src/modules/osd/on-screen-progress.ts
function OnScreenProgress({ vertical, delay }) {
  const indicator = Widget.Icon({
    size: 32,
    className: "font-icon",
    vpack: "end",
    hexpand: true
  });
  const progress2 = Progress({
    vertical,
    width: vertical ? 50 : 250,
    height: vertical ? 250 : 50,
    child: indicator
  });
  const progressBar = Widget.Box({
    vertical: true,
    className: "progress-bar",
    children: [progress2, indicator]
  });
  const revealer = Widget.Revealer({
    transition: "slide_left",
    child: progressBar
  });
  let count = 0;
  function show() {
    progressBar.toggleClassName("muted", Audio.speakers.defaultSpeaker.muted);
    indicator.icon = Audio.speakers.defaultSpeaker.muted ? icons_default.volume.muted : icons_default.volume.unmuted;
    progress2.setValue(Audio.speakers.defaultSpeaker.volume);
    revealer.reveal_child = true;
    count++;
    Utils.timeout(delay, () => {
      count--;
      if (count === 0)
        revealer.reveal_child = false;
    });
  }
  return revealer.hook(Audio.speakers.defaultSpeaker, show, "notify::volume").hook(Audio.speakers.defaultSpeaker, show, "notify::muted");
}

// src/modules/osd/volume.ts
var VolumeOSD = () => Widget.Window({
  name: "osd",
  layer: "overlay",
  clickThrough: true,
  anchor: ["right", "left", "top", "bottom"],
  child: Widget.Box({
    className: "overlay",
    expand: true,
    child: Widget.Overlay({
      child: Widget.Box({
        expand: true
      })
    }, Widget.Box({
      hpack: "end",
      vpack: "center",
      child: OnScreenProgress({ vertical: true, delay: 2500 })
    }))
  })
});
// src/modules/notification-center/index.ts
import GLib3 from "gi://GLib";
var time = function(time2, format = "%H:%M") {
  return GLib3.DateTime.new_from_unix_local(time2).format(format);
};
var Header = function() {
  const dndButton = Widget.Button({
    className: "dnd",
    child: Widget.Icon(),
    onClicked: () => notifications2.dnd = !notifications2.dnd
  }).hook(notifications2, (self) => {
    self.child.icon = notifications2.dnd ? icons_default.notifications.dnd.enabled : icons_default.notifications.dnd.disabled;
    self.toggleClassName("on", notifications2.dnd);
  }, "notify::dnd");
  return Widget.CenterBox({
    className: "header",
    startWidget: Widget.Box({
      child: dndButton
    }),
    centerWidget: Widget.Box({
      child: Widget.Label({
        className: "title",
        label: "Notifications"
      }),
      hpack: "center"
    }),
    endWidget: Widget.Box({
      hpack: "end",
      child: Widget.Button({
        className: "clear",
        visible: _notifications.as((n) => n.length > 0),
        child: Widget.Box({
          spacing: 8,
          children: [
            Widget.Icon({ icon: icons_default.notifications.clear }),
            Widget.Label({
              label: "Clear"
            })
          ]
        }),
        onPrimaryClick: () => notifications2.clear()
      })
    })
  });
};
var NotificationIcon = function({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Box({
      vpack: "start",
      hexpand: false,
      className: "icon",
      css: `background-image: url("${image}");`
    });
  }
  let icon = "dialog-information-symbolic";
  if (Utils.lookUpIcon(app_icon))
    icon = app_icon;
  if (Utils.lookUpIcon(app_entry || ""))
    icon = app_entry || "";
  return Widget.Box({
    vpack: "start",
    hexpand: false,
    className: "icon",
    css: `
          min-width: 78px;
          min-height: 78px;
      `,
    child: Widget.Icon({
      icon,
      size: 58,
      hpack: "center",
      hexpand: true,
      vpack: "center",
      vexpand: true
    })
  });
};
var Notification = function(notification) {
  const content = Widget.Box({
    className: "content",
    children: [
      NotificationIcon(notification),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({
                className: "title",
                xalign: 0,
                justification: "left",
                hexpand: true,
                maxWidthChars: 24,
                truncate: "end",
                wrap: true,
                label: notification.summary.trim(),
                useMarkup: true
              }),
              Widget.Label({
                className: "time",
                vpack: "start",
                label: time(notification.time)
              }),
              Widget.Button({
                className: "close-button",
                vpack: "start",
                child: Widget.Icon(icons_default.ui.close),
                onClicked: notification.close
              })
            ]
          }),
          Widget.Label({
            className: "description",
            hexpand: true,
            useMarkup: true,
            xalign: 0,
            justification: "left",
            label: notification.body.trim(),
            maxWidthChars: 24,
            wrap: true
          })
        ]
      })
    ]
  });
  const actionsbox = notification.actions.length > 0 ? Widget.Box({
    className: "actions horizontal",
    children: notification.actions.map((action) => Widget.Button({
      className: "action",
      onClicked: () => notification.invoke(action.id),
      hexpand: true,
      child: Widget.Label(action.label)
    }))
  }) : null;
  return Widget.Box({
    className: `notification ${notification.urgency}`,
    vexpand: false,
    hexpand: true,
    vertical: true,
    children: actionsbox ? [content, actionsbox] : [content]
  });
};
var List = function() {
  const map = new Map;
  function remove(id) {
    const notif = map.get(id);
    if (notif) {
      notif.destroy();
      map.delete(id);
    }
  }
  const list = Widget.Box({
    vertical: true,
    vexpand: true,
    className: "list",
    children: notifications2.notifications.reverse().map((n) => {
      const notif = Notification(n);
      map.set(n.id, notif);
      return notif;
    })
  }).hook(notifications2, (_, id) => {
    remove(id);
  }, "closed").hook(notifications2, (self, id) => {
    if (id !== undefined) {
      if (map.has(id)) {
        remove(id);
      }
      const notif = notifications2.getNotification(id);
      if (!notif)
        return;
      const notifWidget = Notification(notif);
      map.set(id, notifWidget);
      self.children = [notifWidget, ...self.children];
    }
  }, "notified");
  return Widget.Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    className: "list-container",
    vexpand: true,
    child: list
  });
};
var _NotificationCenter = function() {
  return Widget.Box({
    hpack: "center",
    vpack: "start",
    vertical: true,
    className: "notification-center",
    children: [Header(), List()]
  });
};
var WINDOW_NAME3 = "notification-center";
var notifications2 = await Service.import("notifications");
var _notifications = notifications2.bind("notifications");
var NotificationCenter = () => {
  return PopupWindow({
    exclusivity: "exclusive",
    name: WINDOW_NAME3,
    layout: "top-center",
    child: _NotificationCenter()
  });
};

// src/config.ts
async function start() {
  App.addIcons(App.configDir + "/icons");
  App.applyCss(App.configDir + "/config.css");
  App.config({
    windows: [
      TopBar(),
      AppLauncher(),
      PowerMenu(),
      VolumeOSD(),
      NotificationCenter()
    ]
  });
  globalThis.ags = { App };
  globalThis.powermenu = { toggle: togglePowerMenu };
}
var checkVersion = function() {
  print("checking version...");
  if (pkgVersion !== agsVersion && !skipCheck) {
    print("Error: AGS version mismatch!");
    print(`To skip the check run "SKIP_CHECK=true ags"`);
    App.connect("config-parsed", (app) => app.Quit());
    return {};
  } else {
    print("version OK");
    start();
  }
};
var agsVersion = readFile(App.configDir + "/ags-version.txt");
var pkgVersion = pkg.version;
var skipCheck = GLib4.getenv("SKIP_CHECK") === "true";
print(`expected AGS version: [${agsVersion}]`);
print(`current AGS version: [${pkgVersion}]`);
print(`skip check: ${skipCheck}`);
await checkVersion();
