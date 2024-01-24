{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.webflo.modules.user;
  inherit (lib) mkOption types;
in {
  options.webflo.modules.user = {
    name = mkOption {type = types.str;};
    uid = mkOption {
      type = types.int;
      default = 1000;
    };
  };

  # config = {
  #   users.users.${cfg.name} = {
  #     isNormalUser = true;
  #     extraGroups = ["networkmanager" "wheel"];
  #     shell = pkgs.zsh;
  #     inherit (cfg) uid;
  #   };

  #   programs.zsh.enable = true;
  # };
}
