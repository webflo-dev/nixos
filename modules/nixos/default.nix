{
  pkgs,
  hostUsers,
  ...
}: {
  imports = [
    ../defaults/nixos
    ./bluetooth.nix
    ./development.nix
    ./docker.nix
    ./fingerprint.nix
    ./fonts.nix
    ./hyprland.nix
    ./logitech.nix
    ./nvidia.nix
    ./pipewire.nix
    ./thunar.nix
    ./video.nix
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
