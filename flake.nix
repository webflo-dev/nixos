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

    mkHost = {
      hostname,
      username,
      userId ? 1000,
      ...
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules =
          ### Custom modules
          (moduleList "modules" "system")
          ++ (moduleList "presets" "system")
          ++ (moduleList "modules" "webflo")
          ++ [
            ### Host specific configuration

            ./hosts/${hostname}/hardware-configuration.nix
            ./hosts/${hostname}/system.nix

            ### Home-manager
            {
              home-manager.users.${username} = {
                imports =
                  (moduleList "modules" "home-manager")
                  ++ (moduleList "presets" "home-manager");
              };
            }

            ### Required configuration
            {
              system.stateVersion = "23.11";
              webflo.settings = {
                hostName = hostname;
                user = {
                  name = username;
                  uid = userId;
                };
              };

              home-manager.users.${username} = {
                home.stateVersion = "23.11";
                imports = [
                  ./hosts/${hostname}/home-manager.nix
                ];
              };
            }
          ];
      };
  in {
    nixosConfigurations = {
      bureau = mkHost {
        hostname = "bureau";
        username = "florent";
      };

      # xps13 = mkHost {
      #   hostname = "xps13";
      #   username = "florent";
      # };

      # vm = mkHost {
      #   hostname = "vm";
      #   username = "florent";
      #   sharefolder = "webflo";
      # };
    };
  };
}
