{
  hostName,
  username,
  uid,
  ...
}: {
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
    ../hosts/${hostName}/users/${username}
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
  age.secretsDir = mkIf (uid != null) "/run/user/${toString uid}/agenix";
}
