{
  pkgs,
  inputs,
  hostUsers,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim
    ./defaults/nixos
    ./nixos
  ];

  programs.zsh.enable = true;

  users.users =
    builtins.mapAttrs (
      username: uid: {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel"];
        shell = pkgs.zsh;
        home = "/home/${username}";
        inherit uid;
      }
    )
    hostUsers;
}
