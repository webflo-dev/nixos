{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
  ];

  system.stateVersion = "23.11";
  webflo.settings = {
    user = {
      name = "florent";
      uid = 1000;
    };
    monitor = {
      name = "DP-2";
      resolution = {
        width = 3840;
        height = 2160;
      };
      refreshRate = 144;
    };
  };

  home-manager.users.${config.webflo.settings.user.name} = {
    home.stateVersion = "23.11";
    imports = [
      ./home-manager.nix
    ];
  };
}
