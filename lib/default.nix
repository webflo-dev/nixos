{
  nixpkgs,
  inputs,
  ...
}: let
  modules = folder:
    map (x: ../modules/${folder}/${x})
    (builtins.attrNames (builtins.readDir ../modules/${folder}));

  mkHomeManagerUserModule = hostName: username: uid: {
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
    age.secretsDir = nixpkgs.lib.mkIf (uid != null) "/run/user/${toString uid}/agenix";
  };

  mkHomeManagerConfiguration = hostName: username: uid:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {system = "x86_64-linux";};
      extraSpecialArgs = {inherit inputs;};
      modules =
        modules "home-manager"
        ++ [(mkHomeManagerUserModule hostName username uid)]
        ++ [../hosts/${hostName}/users/${username}];
    };

  mkNixosConfiguration = hostName: users:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules =
        (modules "defaults")
        ++ (modules "system")
        ++ (modules "webflo")
        ++ [
          ({pkgs, ...}: {
            webflo.modules.network.hostName = hostName;

            programs.zsh.enable = true;

            environment.systemPackages = [
              pkgs.home-manager
            ];

            users.users =
              builtins.mapAttrs (username: uid: {
                isNormalUser = true;
                extraGroups = ["networkmanager" "wheel"];
                shell = pkgs.zsh;
                inherit uid;
              })
              users;

            home-manager = {
              sharedModules = modules "home-manager";
              users = builtins.mapAttrs (mkHomeManagerUserModule hostName) users;
            };
          })
        ]
        ### Host configuration
        ++ [../hosts/${hostName}];
    };
in {
  mkHomeManagerConfigurations = hosts:
    builtins.listToAttrs
    (builtins.concatLists
      (builtins.map (hostName: (builtins.map (user: {
          name = "${user.name}@${hostName}";
          value = mkHomeManagerConfiguration hostName user.name user.value;
        }) (nixpkgs.lib.attrsets.attrsToList hosts.${hostName})))
        (builtins.attrNames hosts)));

  mkNixosConfigurations = hosts:
    builtins.mapAttrs mkNixosConfiguration hosts;
}
