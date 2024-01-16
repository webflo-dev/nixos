{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (config.webflo) settings;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.extraSpecialArgs = {inherit inputs settings;};
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # home-manager.users."${settings.user.name}" = import ./hm.nix;
  home-manager.users."${settings.user.name}" = {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];

    config = {
      # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
      age.secretsDir = "/run/user/${toString settings.user.uid}/agenix";

      programs.home-manager.enable = true;

      home = {
        username = settings.user.name;
        homeDirectory = "/home/${settings.user.name}";
      };
    };
  };
}
