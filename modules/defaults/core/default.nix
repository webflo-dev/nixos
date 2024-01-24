{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.core;
  inherit (lib) mkOption types;
in {
  options.webflo.modules.core = {
    cleanOptions = mkOption {
      description = "Options given to nix-collect-garbage when the garbage collector is run automatically.";
      type = types.str;
      default = "--delete-older-than 30d";
    };
  };

  config = {
    security = {
      tpm2 = {
        enable = true;
        pkcs11.enable = true;
      };
      sudo.wheelNeedsPassword = true;
      sudo.execWheelOnly = true;
    };

    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = cfg.cleanOptions;
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
