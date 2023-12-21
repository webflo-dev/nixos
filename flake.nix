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
  };


  outputs = { self, nixpkgs, ... } @ inputs:
    let
      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file

      mkHost = { system, hostname, username, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules = [
            { imports = builtins.attrValues self.customModules; }
            ./hosts/${hostname}/system.nix
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
