{lib, ...}: {
  documentation = {
    # Whether to install documentation of packages from environment.systemPackages into the generated system path. See "Multiple-output packages" chapter in the nixpkgs manual for more info.
    enable = lib.mkDefault true;
    # Whether to install manual pages and the man command. This also includes "man" outputs.
    man.enable = lib.mkDefault true;
    # Whether to install documentation distributed in packages' /share/doc. Usually plain text and/or HTML. This also includes "doc" outputs.
    doc.enable = lib.mkForce false;
    # Installs man and doc pages if they are enabled
    # Takes too much time and are not cached
    nixos.enable = lib.mkForce false;
    # Whether to install info pages and the info command. This also includes "info" outputs.
    info.enable = lib.mkForce false;
  };
}
