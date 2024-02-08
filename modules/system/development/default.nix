{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.development;
  inherit (lib) mkEnableOption mkIf mkOption types mkMerge;
in {
  options.webflo.modules.development = {
    enable = mkEnableOption "development module";
    usernames = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    go = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
    rust = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
    nix = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      security.pam.loginLimits =
        builtins.map (
          username: {
            domain = username;
            type = "soft";
            item = "nofile";
            value = "8192";
          }
        )
        cfg.usernames;

      environment.systemPackages = with pkgs; [
        inotify-tools
      ];

      programs = {
        direnv = {
          enable = true;
          loadInNixShell = true;
          nix-direnv.enable = true;
        };
      };
    }

    (mkIf cfg.go.enable {
      environment.systemPackages = with pkgs; [
        go
      ];
    })

    (mkIf cfg.rust.enable {
      environment.systemPackages = with pkgs; [
        rustup
      ];
    })

    (mkIf cfg.nix.enable {
      environment.systemPackages = with pkgs; [
        nixd
        nil
        statix
        alejandra
      ];
    })
  ]);
}
