{ pkgs, ... }:
{
  programs.zsh.enable = true;

  programs.fzf.fuzzyCompletion = true;
  programs.fzf.keybindings = true;

  environment.systemPackages = with pkgs; [
    fzf
  ];

}
