{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    btop
    croc
    curl
    fd
    gdu
    gitui
    neovim
    ripgrep
    unzip
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
