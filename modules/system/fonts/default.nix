{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.desktop.fonts;
  inherit (lib) mkEnableOption mkIf;
  defaultFont = "Luciole";
  monospaceFont = "Cartograph CF";
in {
  options.webflo.modules.desktop.fonts = {
    enable = mkEnableOption "Fonts module";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts-color-emoji
        # monaspace
        (nerdfonts.override {
          fonts = ["NerdFontsSymbolsOnly"];
        })
        inputs.webflo-pkgs.packages.${pkgs.system}.font-luciole
      ];

      fontconfig = {
        enable = true;
        hinting = {
          enable = true;
          autohint = false;
          style = "slight";
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };

        defaultFonts = {
          serif = [
            defaultFont
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          sansSerif = [
            defaultFont
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          monospace = [
            monospaceFont
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      font-manager
    ];
  };
}
