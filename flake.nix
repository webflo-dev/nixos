{
  description = "NixOS & Home manager (webflo edition)";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

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
    ...
  } @ inputs: let
    moduleList = type: folder: map (x: ./. + "/${type}/${folder}/${x}") (builtins.attrNames (builtins.readDir (./. + "/${type}/${folder}")));

    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules =
          (moduleList "modules" "system")
          ++ (moduleList "modules" "webflo")
          ++ [
            {
              home-manager.sharedModules = moduleList "modules" "home-manager";
            }
          ]
          ++ [
            {webflo.settings.hostName = hostName;}
            ./hosts/${hostName}
          ];
      };

    mkHosts = builtins.listToAttrs (builtins.map (host: {
        name = host;
        value = mkHost host;
      })
      (builtins.attrNames (builtins.readDir ./hosts)));
  in {
    nixosConfigurations = mkHosts;
  };
}
