{pkgs,...}: {
  imports = [
    ./agenix.nix
    ./boot.nix
    ./core.nix
    ./direnv.nix
    ./doc.nix
    ./locales.nix
    ./network.nix
    ./pin-channel.nix
  ];

  # Nix stuff for nix development
  environment.systemPackages = with pkgs; [
    nixd
    nil
    statix
    alejandra
  ];
}
