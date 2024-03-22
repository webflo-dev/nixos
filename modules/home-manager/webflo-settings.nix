{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  monitorModule = types.submodule {
    options = {
      name = mkOption {type = types.str;};
      resolution = {
        width = mkOption {type = types.int;};
        height = mkOption {type = types.int;};
      };
      refreshRate = mkOption {
        type = types.int;
        default = 60;
      };
      bitDepth = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };
  };
in {
  options.webflo.settings = {
    monitors = mkOption {
      type = types.listOf monitorModule;
      default = [];
    };
  };
}
