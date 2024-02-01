{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    webflo-pkgs = {
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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    ...
  } @ inputs: let
    lib = import ./lib {inherit inputs nixpkgs;};

    hosts = {
      bureau = {
        florent = 1000;
      };
      xps13 = {
        florent = 1000;
      };
    };
  in {
    nixosConfigurations = lib.mkNixosConfigurations hosts;
    homeConfigurations = lib.mkHomeManagerConfigurations hosts;
  };
}
