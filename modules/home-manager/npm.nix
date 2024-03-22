{config, ...}: let
  inherit
    (config.webflo.xdg-dirs)
    XDG_DATA_HOME
    XDG_CACHE_HOME
    ;
in {
  xdg.configFile = {
    "npm/npmrc".text = ''
      prefix=${XDG_DATA_HOME}/npm
      cache=${XDG_CACHE_HOME}/npm
    '';
  };
}
