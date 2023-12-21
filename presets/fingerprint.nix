{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libfprint-2-tod1-goodix
  ];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

}
