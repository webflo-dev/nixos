import { Widget } from "../ags.js";

export const FaIcon = ({ class_name, ...props }) =>
  Widget.Label({
    class_name: `icon ${class_name ?? ""}`,
    ...props,
  });
