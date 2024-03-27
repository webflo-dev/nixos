let
  pkgs = import <nixpkgs> {
    config.permittedInsecurePackages = [
      "nix-2.16.2"
    ];
  };
in
  pkgs.mkShell {
    packages = with pkgs; [
      nixd
      nil
      statix
      alejandra
    ];
  }
