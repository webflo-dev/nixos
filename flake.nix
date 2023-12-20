{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    webflo = {
      url = "github:webflo-dev/nixos-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, ... } @ inputs:
    {
      nixosConfigurations = {
        xps13 =
          let
            vars = {
              system = "x86_64-linux";
              hostname = "xps13";
              username = "florent";
            };
          in
          nixpkgs.lib.nixosSystem {
            system = vars.system;
            specialArgs = {
              inherit inputs vars;
            };
            modules = [
              ./hosts/xps13/system.nix
            ];
          };
      };
    };
}
