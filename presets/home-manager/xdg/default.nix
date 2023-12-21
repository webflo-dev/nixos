{ config, ... }:
let
  homeDir = config.home.homeDirectory;

  XDG_CONFIG_HOME = "${homeDir}/.config";
  XDG_CACHE_HOME = "${homeDir}/.cache";
  XDG_DATA_HOME = "${homeDir}/.local/share";
  XDG_STATE_HOME = "${homeDir}/.local/state";

  # XDG_RUNTIME_DIR = "/run/user/$(id -u)";
  XDG_DOWNLOAD_DIR = "${homeDir}/Downloads";
  XDG_DOCUMENTS_DIR = "${homeDir}/Documents";
  XDG_PICTURES_DIR = "${homeDir}/Pictures";
  XDG_VIDEOS_DIR = "${homeDir}/Videos";
in
{
  xdg = {
    enable = true;

    configHome = XDG_CONFIG_HOME;
    cacheHome = XDG_CACHE_HOME;
    dataHome = XDG_DATA_HOME;
    stateHome = XDG_STATE_HOME;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = null;
    documents = XDG_DOCUMENTS_DIR;
    download = XDG_DOWNLOAD_DIR;
    music = null;
    pictures = XDG_PICTURES_DIR;
    publicShare = null;
    templates = null;
    videos = XDG_VIDEOS_DIR;
  };
}
