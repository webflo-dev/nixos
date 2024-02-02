{
  hostName,
  users,
  ...
}: {
  pkgs,
  inputs,
  ...
}: let
  homeManagerUserModule = import ./home-manager-user.nix;

  mkNixosUser = username: uid: {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    inherit uid;
  };

  mkHomeManagerUser = username: uid: {
    imports = [
      (homeManagerUserModule {inherit username uid;})
      ../hosts/${hostName}/users/${username}
    ];
  };
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  webflo.modules.network = {inherit hostName;};

  environment.systemPackages = [
    pkgs.home-manager
  ];

  programs.zsh.enable = true;
  users.users = builtins.mapAttrs mkNixosUser users;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = builtins.mapAttrs mkHomeManagerUser users;
  };
}
