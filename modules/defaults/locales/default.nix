{
  config,
  lib,
  pkgs,
  ...
}: let
  timeZone = "Europe/Paris";
  defaultLocale = "en_US.UTF-8";
  dateTimeLocale = "fr_FR.UTF-8";
  consoleKeyMap = "fr";
in {
  time = {
    inherit timeZone;
  };

  i18n = {
    inherit defaultLocale;

    extraLocaleSettings = {
      LC_ADDRESS = dateTimeLocale;
      LC_IDENTIFICATION = dateTimeLocale;
      LC_MEASUREMENT = dateTimeLocale;
      LC_MONETARY = dateTimeLocale;
      LC_NAME = dateTimeLocale;
      LC_NUMERIC = dateTimeLocale;
      LC_PAPER = dateTimeLocale;
      LC_TELEPHONE = dateTimeLocale;
      LC_TIME = dateTimeLocale;
    };

    supportedLocales = [
      "${defaultLocale}/UTF-8"
      "${dateTimeLocale}/UTF-8"
    ];
  };

  console.keyMap = consoleKeyMap;
}
