{
  pkgs,
  lib,
  config,
  inputs,
  hostName,
  hostUsers,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.agenix.homeManagerModules.default
      inputs.nixvim.homeManagerModules.nixvim
      ./defaults/home-manager
      ./home-manager
    ];

    users =
      builtins.mapAttrs (username: uid: {
        imports = [
          ../hosts/${hostName}/users/${username}
        ];

        nixpkgs.config.allowUnfree = true;

        programs.home-manager.enable = true;

        home = {
          inherit username;
          homeDirectory = config.users.users.${username}.home;
        };

        # Same as default but with expanded path. Because Git for example doesn't work with env variable in config file.
        age.secretsDir = "${builtins.getEnv "XDG_RUNTIME_DIR"}/agenix";
      })
      hostUsers;
  };
}
