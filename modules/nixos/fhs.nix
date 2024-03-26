{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.fhs;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.fhs = {
    enable = mkEnableOption "FHS support";
  };

  config = mkIf cfg.enable {
    services.envfs.enable = true;

    environment.systemPackages = with pkgs; [
      fuse
    ];

    programs.nix-ld = {
      enable = true;
      # libraries = with pkgs; [
      #   stdenv.cc.cc
      #   openssl
      #   curl
      #   glib
      #   util-linux
      #   icu
      #   libunwind
      #   libuuid
      #   zlib
      #   libsecret
      #   fuse
      #   fuse3
      #   nss
      #   expat
      # ];
    };
  };
}
