{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    webflo = {
      url = "github:webflo-dev/nixos-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      customModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      mkHost = { system, hostname, username, userId, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules = [
            { imports = builtins.attrValues customModules; }
            home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.default
            ./hosts/${hostname}/system
            {
              home-manager.extraSpecialArgs = { inherit inputs vars; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = [
                  inputs.agenix.homeManagerModules.default
                  {
                    # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
                    age.secretsDir = "/run/user/${toString vars.userId}/agenix";
                  }
                  ./hosts/${hostname}/home-manager
                ];
              };
            }
          ];
        };
    in
    {


      nixosConfigurations = {
        xps13 = mkHost {
          system = "x86_64-linux";
          hostname = "xps13";
          username = "florent";
          userId = 1000;
        };

        vm = mkHost {
          system = "x86_64-linux";
          hostname = "vm";
          username = "florent";
          userId = 1000;
          sharefolder = "webflo";
        };
      };
    };
}
