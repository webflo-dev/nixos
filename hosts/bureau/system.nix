{ pkgs, ... }:

{
  services.fwupd.enable = true;

  webflo.modules = {
    nvidia.enable = true;
  };

  webflo.presets = {
    desktop = {
      enable = true;
    };
    work = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    udiskie
  ];
}
