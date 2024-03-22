{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    webflo-pkgs = {
      url = "github:webflo-dev/nixos-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      # url = "github:Aylur/ags/v1.8.0";
      url = "github:Aylur/ags?ref=5dec6c7f37be13781144a7964e75cc00c7d7045f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # url = "github:nix-community/nixvim/nixos-23.11";
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    ...
  } @ inputs: {
    nixosConfigurations =
      builtins.mapAttrs (
        hostName: _: let
          hostUsers = import ./hosts/${hostName}/users.nix;
        in
          nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs hostName hostUsers;};
            modules = [
              inputs.nixvim.nixosModules.nixvim
              ./modules/nixos
              ./modules/home-manager.nix
              ./hosts/${hostName}/nixos.nix
              {
                nixpkgs.config.permittedInsecurePackages = [
                  "nix-2.16.2"
                ];
              }
            ];
          }
      )
      (builtins.readDir ./hosts);
  };
}
