{ pkgs, inputs, vars, ... }:
{
  programs.home-manager.enable = true;

  home = {
    stateVersion = "23.11";
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
    packages = with pkgs; [
      croc
      gitui
    ];
  };
}

