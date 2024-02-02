{lib, ...}: let
  nixosSystemModule = import ./nixos-system.nix;
  homeManagerUserModule = import ./home-manager-user.nix;
in {
  inherit nixosSystemModule homeManagerUserModule;

  modules = folder:
    map (x: ../modules/${folder}/${x})
    (builtins.attrNames (builtins.readDir ../modules/${folder}));

  mkNixosConfigurations = mkNixosSystem: hosts:
    builtins.mapAttrs (hostName: users:
      mkNixosSystem {inherit hostName users;})
    hosts;

  mkHomeManagerConfigurations = mkHomeManagerConfiguration: hosts:
    lib.foldl' (acc: elem: acc // elem) {}
    (lib.flatten (
      lib.mapAttrsToList (
        hostName: users:
          lib.mapAttrsToList (
            username: uid: {
              "${username}@${hostName}" = mkHomeManagerConfiguration {inherit hostName username uid;};
            }
          )
          users
      )
      hosts
    ));
}
