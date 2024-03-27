{
  config,
  lib,
  pkgs,
  hostUsers,
  ...
}: let
  cfg = config.webflo.modules.virtualisation;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.webflo.modules.virtualisation = {
    enable = mkEnableOption "Virtualisation";
  };

  config = mkIf cfg.enable {
    users.groups = {
      "libvirtd".members = builtins.attrNames hostUsers;
      "kvm".members = builtins.attrNames hostUsers;
    };

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          ovmf.enable = true;
          ovmf.packages = [
            (pkgs.OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
          # runAsRoot = false;
          swtpm.enable = true;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };
  };
}
