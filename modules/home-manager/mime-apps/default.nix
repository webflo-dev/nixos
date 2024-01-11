{ config, lib, pkgs, ...}:
let
  cfg = config.webflo.modules.mimeApps;
  inherit (lib) mkEnableOption mkOption mkIf types;
  browser = cfg.browser;
in
{
  options.webflo.modules.mimeApps = {
    enable = mkEnableOption "mime-apps module";
    browser = mkOption {
      type = types.str;
      default = "brave-browser.desktop";
    };
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/webcal" = [ browser ];
        "x-scheme-handler/mailto" = [ browser ];
        "application/json" = [ browser ];
        "application/pdf" = [ browser ];
        "application/xhtml+xml" = [ browser ];
        "text/html" = [ browser ];
        "text/xml" = [ browser ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https" = [ browser ];
      };
    };
  };
}
