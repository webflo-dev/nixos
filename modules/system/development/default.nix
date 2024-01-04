{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.modules.development;
  inherit (lib) mkEnableOption mkOption mkIf types;
in
{
  options.webflo.modules.development = {
    enable = mkEnableOption "development module";
    username = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    security.pam.loginLimits = [
      {
        domain = cfg.username;
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];

    environment.systemPackages = with pkgs; [
      inotify-tools
      go
      rustup
      vscode
      gitui
    ];

    programs = {
      direnv = {
        enable = true;
        loadInNixShell = true;
        nix-direnv.enable = true;
      };
    };
  };
}