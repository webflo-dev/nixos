{pkgs, ...}: let
  package = pkgs.nodePackages.graphql-language-service-cli;
in {
  programs.nixvim = {
    extraPackages = [package];

    plugins.lsp.enabledServers = [
      {
        name = "graphql";
        extraOptions = {
          autoStart = true;
        };
      }
    ];
  };
}
