{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (config.webflo.xdg-dirs)
    XDG_CONFIG_HOME
    XDG_CACHE_HOME
    XDG_DATA_HOME
    XDG_STATE_HOME
    XDG_DOWNLOAD_DIR
    XDG_DOCUMENTS_DIR
    XDG_PICTURES_DIR
    XDG_VIDEOS_DIR
    # XDG_RUNTIME_DIR
    
    ;
in {
  home.packages = with pkgs; [
    xdg-utils
  ];

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

  home.sessionVariables = {
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    KDEHOME = "${XDG_CONFIG_HOME}/kde";
    LESSHISTFILE = "${XDG_DATA_HOME}/less/history";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_TMP = "\${XDG_RUNTIME_DIR}/npm";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    GOPATH = "${XDG_DATA_HOME}/go";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
  };
}
