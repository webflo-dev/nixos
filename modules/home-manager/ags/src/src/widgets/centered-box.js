import { Widget } from "../ags.js";

export const CenteredBox = (boxProps) =>
  Widget.Box({
    vertical: true,
    vpack: "center",
    hpack: "center",
    vexpand: true,
    hexpand: true,
    ...boxProps,
  });
