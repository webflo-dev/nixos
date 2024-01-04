{ pkgs, vars, ... }:

{
  zramSwap.enable = true;
  services.fwupd.enable = true;

  webflo.modules = {
    bluetooth.enable = true;
    fingerprint.enable = true;
  };

  webflo.presets = {
    desktop = {
      enable = true;
      username = vars.username;
    };
    work = {
      enable = true;
      username = vars.username;
    };
  };

  environment.systemPackages = with pkgs; [
    udiskie
  ];

  system.stateVersion = "23.11";
}
