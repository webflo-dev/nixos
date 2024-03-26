{pkgs, ...}: {
  home.pointerCursor = {
    # gtk.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS-Monterey";
    size = 24;
  };
}
