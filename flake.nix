{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    webflo = {
      url = "github:webflo-dev/nixos-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, ... } @ inputs:
    let
      mkHost = { system, hostname, username, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules = [
            ./hosts/${hostname}/system.nix
          ];
        };
    in
    {
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
