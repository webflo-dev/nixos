{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  homeDir = config.home.homeDirectory;
in {
  options.webflo.xdg-dirs = {
    XDG_CONFIG_HOME = mkOption {
      type = types.str;
      default = "${homeDir}/.config";
    };
    XDG_CACHE_HOME = mkOption {
      type = types.str;
      default = "${homeDir}/.cache";
    };
    XDG_DATA_HOME = mkOption {
      type = types.str;
      default = "${homeDir}/.local/share";
    };
    XDG_STATE_HOME = mkOption {
      type = types.str;
      default = "${homeDir}/.local/state";
    };

    XDG_DOWNLOAD_DIR = mkOption {
      type = types.str;
      default = "${homeDir}/Downloads";
    };
    XDG_DOCUMENTS_DIR = mkOption {
      type = types.str;
      default = "${homeDir}/Documents";
    };
    XDG_PICTURES_DIR = mkOption {
      type = types.str;
      default = "${homeDir}/Pictures";
    };
    XDG_VIDEOS_DIR = mkOption {
      type = types.str;
      default = "${homeDir}/Videos";
    };

    XDG_RUNTIME_DIR = mkOption {
      type = types.str;
      default = builtins.getEnv "XDG_RUNTIME_DIR";
    };
  };
}
