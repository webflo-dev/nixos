{ pkgs, vars, ... }:
{
  security.pam.loginLimits = [
    {
      domain = "${vars.username}";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];

  environment.systemPackages = with pkgs; [
    inotify-tools
    go
    rustup
    vscode
    gitui
  ];

  programs = {
    direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
  };
}
