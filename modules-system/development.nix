{ vars, ... }:
{
  security.pam.loginLimits = [
    {
      domain = "${vars}";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
}
