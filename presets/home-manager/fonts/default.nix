{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  xdg.dataFile."fonts/test.sh".source = ./test.sh;

}
