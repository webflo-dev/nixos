import { Confirm, PowerMenu as PowerMenuWindow } from "./power-menu.js";

export { toggle as togglePowerMenu } from "./power-menu.js";
export const PowerMenu = () => [PowerMenuWindow(), Confirm()];
