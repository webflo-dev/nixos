import { Applications } from "./ags.js";

const regex = new RegExp(/(\w+=("[^"]*"|[^ ]*))/g);

export function readOutputScript(source) {
  const firstSeparator = source.indexOf(" ");

  const signalName = source.substring(0, firstSeparator);

  const values = source.substring(firstSeparator + 1);
  const pairs = values.match(regex);
  const info = {};
  if (pairs) {
    pairs.forEach((pair) => {
      const [key, value] = pair.split("=");
      info[key] = value.replace(/"/g, "");
    });
  }

  return [signalName, info];
}

export function getIconName(name) {
  const searchableName = name.toLowerCase();
  const app = Applications.list.find((app) => {
    const appName = app.name.toLowerCase();
    if (appName === searchableName) return true;
    return appName.includes(searchableName);
  });
  return app?.iconName;
}
