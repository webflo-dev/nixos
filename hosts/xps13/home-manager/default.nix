{ pkgs, inputs, vars, ... }:
{
  imports = [
    # Core presets
    ../../../presets/home-manager/xdg
    ../../../presets/home-manager/zsh
    ../../../presets/home-manager/git

    # Desktop
    ../../../presets/home-manager/kitty
    ../../../presets/home-manager/fonts
    ../../../presets/home-manager/hyprland
    ../../../presets/home-manager/ags
    ../../../presets/home-manager/gtk
    ../../../presets/home-manager/mime-apps

    # Misc
    ../../../presets/home-manager/ranger
    ../../../presets/home-manager/pulsemixer
    ../../../presets/home-manager/neofetch

    # Work
    ../../../presets/home-manager/work
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.11";
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    packages = with pkgs; [
      # CLI
      croc
      ranger

      # Browser
      microsoft-edge
      google-chrome
      brave
      vivaldi

      # Multimedia
      spotify

      # Development
      vscode
    ];
  };
}

