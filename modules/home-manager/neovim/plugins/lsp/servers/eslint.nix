{
  programs.nixvim = {
    plugins.lsp.servers = {
      eslint = {
        enable = true;
        onAttach.function = ''
          client.server_capabilities.documentFormattingProvider = true
          client.server_capabilities.documentRangeFormattingProvider = true

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        '';
      };
    };
  };
}
