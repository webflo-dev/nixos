let
  browser = "microsoft-edge.desktop";
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/webcal" = [ browser ];
      "x-scheme-handler/mailto" = [ browser ];
      "application/json" = [ browser ];
      "application/pdf" = [ browser ];
      "application/xhtml+xml" = [ browser ];
      "text/html" = [ browser ];
      "text/xml" = [ browser ];
      "x-scheme-handler/http" = [ browser ];
      "x-scheme-handler/https" = [ browser ];
    };
  };
}
