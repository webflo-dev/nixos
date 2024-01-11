{ pkgs, vars, ... }:

{
  services.fwupd.enable = true;

  webflo.modules = {
    nvidia.enable = true;
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
}
