{ pkgs, webflo, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-color-emoji
      fira-code
      monaspace
      (nerdfonts.override {
        fonts = [ "NerdFontsSymbolsOnly" ];
      })
      # webflo.luciole
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
        serif = [ "Luciole" "Noto Color Emoji" "Symbols Nerd Font" ];
        sansSerif = [ "Luciole" "Noto Color Emoji" "Symbols Nerd Font" ];
        monospace = [ "Fira Code" "Noto Color Emoji" "Symbols Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
      # localConf = /* xml */ ''
      #   <?xml version="1.0" encoding="UTF-8"?>
      #   <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      #   <fontconfig>
      #     <alias binding="strong">
      #       <family>system-ui</family>
      #       <prefer>
      #         <family>Luciole</family>
      #         <family>Noto Color Emoji</family>
      #         <family>Symbols Nerd Font</family>
      #       </prefer>
      #     </alias>
      #   </fontconfig>
      # '';
    };
  };

}
