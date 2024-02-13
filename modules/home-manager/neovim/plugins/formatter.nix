{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      formattersByFt = {
        javascript = [["prettier" "prettierd"]];
        typescript = [["prettier" "prettierd"]];
        javascriptreact = [["prettier" "prettierd"]];
        typescriptreact = [["prettier" "prettierd"]];
        css = [["prettier" "prettierd"]];
        html = [["prettier" "prettierd"]];
        json = [["prettier" "prettierd"]];
        yaml = [["prettier" "prettierd"]];
        markdown = [["prettier" "prettierd"]];
        graphql = [["prettier" "prettierd"]];
        lua = ["stylua"];
        sh = ["shfmt"];
        scss = [["prettier" "prettierd"]];
        jsonc = [["prettier" "prettierd"]];
        "markdown.mdx" = [["prettier" "prettierd"]];
        go = ["goimports" "gofumpt"];

        # Use the "*" filetype to run formatters on all filetypes.
        # "*" = ["codespell"];

        # Use the "_" filetype to run formatters on filetypes that don't
        # have other formatters configured.
        "_" = ["trim_whitespace"];
      };
      formatOnSave = {
        lspFallback = true;
        timeoutMs = 1000;
      };
    };

    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>cf";
        action = ''
          function()
          	require("conform").format()
          end
        '';
        lua = true;
        options = {desc = "Format code or range";};
      }
    ];
  };
}
