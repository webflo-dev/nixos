{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    webflo.url = "github:webflo-dev/nixos-packages";
  };


  outputs = { nixpkgs, ... } @ inputs:
    {
      nixosConfigurations = {
        xps13 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            hostname = "xps13";
            username = "florent";
          };
          modules =
            [
              ./hosts/xps13/system.nix
            ];
        };
      };
    };
}
