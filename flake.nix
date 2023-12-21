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
      mkHost = { system, hostname, username, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules = [
            { imports = builtins.attrValues self.customModules; }
            ./hosts/${hostname}/system
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs vars; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./hosts/${hostname}/home-manager;
            }
          ];
        };
    in
    {
      customModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      nixosConfigurations = {
        xps13 = mkHost {
          system = "x86_64-linux";
          hostname = "xps13";
          username = "florent";
        };

        vm = mkHost {
          system = "x86_64-linux";
          hostname = "vm";
          username = "florent";
          sharefolder = "webflo";
        };
      };
    };
}
