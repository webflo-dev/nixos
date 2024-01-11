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
      moduleList = type: folder: map (x: ./. + "/${type}/${folder}/${x}") (builtins.attrNames (builtins.readDir (./. + "/${type}/${folder}")));

      mkHost = { system ? "x86_64-linux", hostname, username, userId ? 1000, ... }@vars:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit inputs vars;
          };
          modules =
            ### Custom modules
            (moduleList "modules" "system") ++
            (moduleList "presets" "system") ++ [

              ### Required configuration
              {
                system.stateVersion = "23.11";
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
                  imports =
                    (moduleList "modules" "home-manager") ++
                    (moduleList "presets" "home-manager") ++
                    [
                      inputs.agenix.homeManagerModules.default
                      {
                        # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
                        age.secretsDir = "/run/user/${toString userId}/agenix";
                        programs.home-manager.enable = true;
                        home = {
                          stateVersion = "23.11";
                          username = username;
                          homeDirectory = "/home/${username}";
                        };
                      }
                      ./hosts/${hostname}/home-manager.nix
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
