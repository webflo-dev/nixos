{pkgs, ...}: let
  package = pkgs.dockerfile-language-server-nodejs;
in {
  programs.nixvim = {
    extraPackages = [package];

    plugins.lsp.enabledServers = [
      {
        name = "dockerls";
        extraOptions = {
          autoStart = true;
          cmd = ["${package}/bin/docker-langserver" "--stdio"];
        };
      }
    ];
  };
}
