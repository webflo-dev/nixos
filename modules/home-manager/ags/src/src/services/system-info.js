import { Service, Variable, App } from "../ags.js";
import { readOutputScript } from "../utils.js";

const propertyMapping = {
  CPU: "cpu",
  MEMORY: "memory",
  GPU: "gpu",
};

const properties = Object.values(propertyMapping);

// service properties
const serviceProperties = properties.reduce((accu, prop) => {
  accu[prop] = ["jsobject"];
  return accu;
}, {});

class SystemInfoService extends Service {
  static {
    Service.register(this, {}, serviceProperties);
  }

  _info = {
    cpu: {
      usage: "0",
    },
    memory: {
      total: "0",
      free: "0",
      used: "0",
    },
    gpu: {
      usage: "0",
    },
  };
  _var;

  constructor() {
    super();

    this._var = Variable(this._info, {
      listen: [App.configDir + "/scripts/system.sh", readOutputScript],
    });

    this._var.connect("changed", ({ value }) => {
      const [signalName, info] = value;
      const propName = propertyMapping[signalName];
      this._info[propName] = info;
      this.notify(propName);
    });

    // let self = this;
    // return new Proxy(this, {
    //   get(target, prop) {
    //     print("proxy!!", JSON.stringify(target), prop);
    //     if (properties.includes(prop)) return target._info[prop];
    //     return self[prop];
    //   },
    // });
  }

  get cpu() {
    return this._info.cpu;
  }

  get memory() {
    return this._info.memory;
  }

  get gpu() {
    return this._info.gpu;
  }

  dispose() {
    this._var.dispose();
  }
}

const service = new SystemInfoService();

export default service;
