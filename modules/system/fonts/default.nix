{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.fonts;
  inherit (lib) mkEnableOption mkIf types mkOption;
in {
  options.webflo.modules.fonts = {
    enable = mkEnableOption "Fonts module";

    defaultFont = mkOption {
      type = types.str;
      default = "Luciole";
    };

    monospaceFont = mkOption {
      type = types.str;
      default = "Cartograph CF";
    };

    extraPackages = mkOption {
      type = types.listOf types.path;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs;
        [
          noto-fonts-color-emoji
          # monaspace
          (nerdfonts.override {
            fonts = ["NerdFontsSymbolsOnly"];
          })
          inputs.webflo-pkgs.packages.${pkgs.system}.font-luciole
        ]
        ++ cfg.extraPackages;

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
            cfg.defaultFont
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          sansSerif = [
            cfg.defaultFont
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          monospace = [
            cfg.monospaceFont
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
