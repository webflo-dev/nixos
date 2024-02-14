{
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        javascript = ["eslint_d"];
        typescript = ["eslint_d"];
        javascriptreact = ["eslint_d"];
        typescriptreact = ["eslint_d"];
        dockerfile = ["hadolint"];
        markdown = ["markdownlint"];
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>cl";
        action = ''
          function()
          	require("lint").try_lint()
          end
        '';
        lua = true;
        options = {desc = "Lint current file";};
      }
    ];

    # autoCmd = [
    #   {
    #     desc = "Lint current file";
    #     event = ["BufWritePost" "BufReadPost" "InsertLeave"];
    #     callback.__raw = ''
    #       function()
    #         require('lint').try_lint()
    #         return true
    #       end
    #     '';
    #   }
    # ];
  };
}
