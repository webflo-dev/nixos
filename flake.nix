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
    inherit (nixpkgs) lib;
    inherit
      (import ./lib {inherit lib;})
      modules
      nixosSystemModule
      mkNixosConfigurations
      mkHomeManagerConfigurations
      homeManagerUserModule
      ;

    homeManagerSharedModules = hostName:
      (modules "home-manager")
      ++ (modules "webflo/home-manager")
      ++ [./hosts/${hostName}/users];

    hosts = import ./hosts;

    mkNixosSystem = {
      hostName,
      users,
      ...
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          (modules "defaults")
          ++ (modules "system")
          ++ [{home-manager.sharedModules = homeManagerSharedModules hostName;}]
          ++ [(nixosSystemModule {inherit hostName users;})]
          ++ [./hosts/${hostName}];
      };

    mkHomeManagerConfiguration = {
      hostName,
      username,
      uid,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {inherit inputs;};
        modules =
          (homeManagerSharedModules hostName)
          ++ [(homeManagerUserModule {inherit hostName username uid;})];
      };
  in {
    nixosConfigurations = mkNixosConfigurations mkNixosSystem hosts;
    homeConfigurations = mkHomeManagerConfigurations mkHomeManagerConfiguration hosts;
  };
}
