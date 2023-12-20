{
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
    };
    sudo.wheelNeedsPassword = true;
    sudo.execWheelOnly = true;
  };
}
