{
  config,
  lib,
  ...
}: let
  cfg = config.webflo.settings;
  inherit (lib) mkOption types;
in {
  options.webflo.settings = {
    monitor = {
      name = mkOption {type = types.str;};
      resolution = {
        width = mkOption {type = types.int;};
        height = mkOption {type = types.int;};
      };
      refreshRate = mkOption {type = types.int;};
    };
  };
}
