{ vars, ... }:
{
  security.pam.loginLimits = [
    {
      domain = "${vars.username}";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
}
