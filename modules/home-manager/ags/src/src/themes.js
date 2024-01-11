import { App, Utils } from "./ags.js";

const SourceStyleFile = `${App.configDir}/scss/index.scss`;
export const CssStyleFile = `${App.configDir}/style.css`;

export function cssWatcher() {
  reloadStyles();
  return Utils.subprocess(
    [
      "inotifywait",
      "--recursive",
      "--event",
      "create,modify",
      "-m",
      SourceStyleFile,
    ],
    reloadStyles,
  );
}

export function reloadStyles() {
  Utils.execAsync(`sassc ${SourceStyleFile} ${CssStyleFile}`);
  App.resetCss();
  App.applyCss(CssStyleFile);
}
