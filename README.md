# nixos

## Upgrade NixOS

```
system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
```

This results in the following call with a systemd.timer:

```
nixos-rebuild switch --update-input nixpkgs --no-write-lock-file -L --flake <flake-source> --upgrade
```

source: https://discourse.nixos.org/t/best-practices-for-auto-upgrades-of-flake-enabled-nixos-systems/31255
