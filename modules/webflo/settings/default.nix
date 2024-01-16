{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.webflo.settings = {
    user = {
      name = mkOption {type = types.nonEmptyStr;};
      uid = mkOption {
        type = types.int;
        default = 1000;
      };
    };
    hostName = mkOption {type = types.nonEmptyStr;};
    monitor = {
      name = mkOption {type = types.str;};
      resolution = {
        width = mkOption {type = types.int;};
        height = mkOption {type = types.int;};
      };
      refreshRate = mkOption {type = types.int;};
    };
    desktop = {
      wallpaper = mkOption {type = types.path;};
    };
  };
}
