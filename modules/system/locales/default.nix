{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.locales;
  inherit (lib) mkOption types;
in {
  options.webflo.modules.locales = {
    timeZone = mkOption {
      description = "the time zone used when displaying times and dates";
      type = types.str;
      default = "Europe/Paris";
    };

    defaultLocale = mkOption {
      description = "determines the language for program messages";
      type = types.str;
      default = "en_US.UTF-8";
    };

    dateTimeLocale = mkOption {
      description = "determines the language for program messages";
      type = types.str;
      default = "fr_FR.UTF-8";
    };

    consoleKeyMap = mkOption {
      description = "the keyboard mapping table for the virtual consoles";
      type = types.str;
      default = "fr";
    };
  };

  config = {
    time.timeZone = cfg.timeZone;

    i18n = {
      inherit (cfg) defaultLocale;

      extraLocaleSettings = {
        LC_ADDRESS = cfg.dateTimeLocale;
        LC_IDENTIFICATION = cfg.dateTimeLocale;
        LC_MEASUREMENT = cfg.dateTimeLocale;
        LC_MONETARY = cfg.dateTimeLocale;
        LC_NAME = cfg.dateTimeLocale;
        LC_NUMERIC = cfg.dateTimeLocale;
        LC_PAPER = cfg.dateTimeLocale;
        LC_TELEPHONE = cfg.dateTimeLocale;
        LC_TIME = cfg.dateTimeLocale;
      };

      supportedLocales =
        [
          "en_US.UTF-8"
          "fr_FR.UTF-8"
        ]
        ++ [cfg.defaultLocale];
    };

    console.keyMap = cfg.consoleKeyMap;
  };
}
