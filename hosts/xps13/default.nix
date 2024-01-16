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
      name = "eDP-1";
      resolution = {
        width = 1920;
        height = 1200;
      };
      refreshRate = 60;
    };
  };

  home-manager.users.${config.webflo.settings.user.name} = {
    home.stateVersion = "23.11";
    imports = [
      ./home-manager.nix
    ];
  };
}
