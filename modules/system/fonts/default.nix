{ config, lib, pkgs, inputs, ...}:
let
  cfg = config.webflo.modules.desktop.fonts;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.modules.desktop.fonts = {
    enable = mkEnableOption "Fonts module";
  };
  
    
  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts-color-emoji
        # fira-code
        monaspace
        (nerdfonts.override {
          fonts = [ "NerdFontsSymbolsOnly" ];
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
            "Luciole"
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          sansSerif = [
            "Luciole"
            "Noto Color Emoji"
            "Symbols Nerd Font"
          ];
          monospace = [
            "Cartograph CF"
            # "Fira Code"
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
