{ pkgs, ... }:

{
  zramSwap.enable = true;
  services.fwupd.enable = true;

  webflo.modules = {
    bluetooth.enable = true;
    fingerprint.enable = true;
  };

  webflo.presets = {
    desktop.enable = true;
    work.enable = true;
  };

  environment.systemPackages = with pkgs; [
    udiskie
  ];
}
