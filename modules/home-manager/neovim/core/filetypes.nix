{
  programs.nixvim = {
    filetype = {
      extension = {
        eslintrc = "jsonc";
        mdx = "markdown";
        prettierrc = "json";
      };
      filename = {
        ".eslintrc.json" = "jsonc";
      };
      pattern = {
        ".env" = "sh";
        ".*%.env.*" = "sh";
        "tsconfig.json" = "jsonc";
        "tsconfig.*.json" = "jsonc";
      };
    };
  };
}
