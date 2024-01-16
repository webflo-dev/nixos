{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.development;
  inherit (lib) mkEnableOption mkIf;
  settings = config.webflo.settings;
in {
  options.webflo.modules.development = {
    enable = mkEnableOption "development module";
  };

  config = mkIf cfg.enable {
    security.pam.loginLimits = [
      {
        domain = settings.user.name;
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
