{ pkgs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    croc
    bat
    curl
    fd
    gdu
    neovim
    ripgrep
    unzip
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
