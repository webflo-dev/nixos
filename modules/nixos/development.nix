{
  config,
  lib,
  pkgs,
  hostUsers,
  ...
}: let
  cfg = config.webflo.modules.development;
  inherit (lib) mkEnableOption mkIf mkOption types mkMerge;
in {
  options.webflo.modules.development = {
    enable = mkEnableOption "development module";
  };

  config = mkIf cfg.enable {
    security.pam.loginLimits =
      builtins.map (
        username: {
          domain = username;
          type = "soft";
          item = "nofile";
          value = "8192";
        }
      )
      (builtins.attrNames hostUsers);
  };
}
