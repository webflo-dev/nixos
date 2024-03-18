{
  config,
  pkgs,
  ...
}: let
  username = "florent";
in {
  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
  ];

  zramSwap.enable = true;
  services = {
    fwupd.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  webflo.modules = {
    bluetooth.enable = true;
    fingerprint.enable = true;

    pipewire = {
      enable = true;
      audioGroupMembers = [username];
    };

    video = {
      enable = true;
      videoGroupMembers = [username];
    };

    fonts.enable = true;
    thunar.enable = true;
    hyprland.enable = true;

    development = {
      enable = true;
      usernames = [username];
    };

    docker = {
      enable = true;
      dockerGroupMembers = [username];
    };
  };

  environment.systemPackages = with pkgs;
    [
      udiskie
      mpv
    ]
    ++ [
      slack
      _1password-gui
    ];

  # Need to check TLP configuration
  # services = {
  #   tlp.enable = true;
  #   tlp.settings = {
  #     PLATFORM_PROFILE_ON_BAT = "low-power";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_BOOST_ON_BAT = 1;
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     MEM_SLEEP_ON_BAT = "deep";

  #     PLATFORM_PROFILE_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
  #     CPU_BOOST_ON_AC = 1;
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";

  #     WOL_DISABLE = "Y";
  #   };
  # };
}
