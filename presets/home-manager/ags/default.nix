{ pkgs, inputs, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = [
    pkgs.sassc
  ];

  programs.ags = {
    enable = true;
    configDir = ./src;
  };
}
