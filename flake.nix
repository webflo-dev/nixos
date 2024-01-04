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


  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      customSystemModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules/system + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules/system)));

      customSystemPresets = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./presets/system + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./presets/system)));


      mkHost = { system ? "x86_64-linux", hostname, username, userId ? 1000, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules = [
            ### Custom modules
            { imports = builtins.attrValues customSystemModules; }
            { imports = builtins.attrValues customSystemPresets; }
            
            ### Required configuration
            {
              webflo.modules = {
                network.hostName = hostname;
                user = {
                  username = username;
                  uid = userId;
                };
              };
            }

            ### Host configuration
            ./hosts/${hostname}/hardware-configuration.nix
            ./hosts/${hostname}/system.nix

            ### Home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs vars; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = [
                  inputs.agenix.homeManagerModules.default
                  {
                    # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
                    age.secretsDir = "/run/user/${toString userId}/agenix";
                  }
                  ./hosts/${hostname}/home-manager
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        bureau = mkHost {
          hostname = "bureau";
          username = "florent";
        };

        xps13 = mkHost {
          hostname = "xps13";
          username = "florent";
        };

        vm = mkHost {
          hostname = "vm";
          username = "florent";
          sharefolder = "webflo";
        };
      };
    };
}
