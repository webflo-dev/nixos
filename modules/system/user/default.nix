{
  config,
  pkgs,
  ...
}: let
  inherit (config.webflo) settings;
in {
  config = {
    users.users.${settings.user.name} = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      inherit (settings.user) uid;
    };
    programs.zsh.enable = true;
  };
}
