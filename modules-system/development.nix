{ username, ... }:
{
  security.pam.loginLimits = [
    {
      domain = "${username}";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
}
