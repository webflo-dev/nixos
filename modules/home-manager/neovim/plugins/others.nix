{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-surround
      vim-be-good
      template-string-nvim
    ];

    plugins = {
      hardtime.enable = false;

      which-key = {
        enable = false;
        plugins.spelling.enabled = false;
      };

      trouble.enable = true;

      indent-blankline = {
        enable = true;
        extraOptions = {
          indent = {
            char = "│";
            # char = "▎"
          };
          exclude = {
            filetypes = [
              "help"
              "alpha"
              "dashboard"
              "neo-tree"
              "Trouble"
              "lazy"
              "mason"
              "notify"
              "toggleterm"
              "lazyterm"
            ];
          };
        };
      };

      ts-context-commentstring.enable = true;

      mini = {
        enable = true;
        modules = {
          comment = {
            options = {
              custom_commentstring.__raw = ''
                function()
                  return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
                end
              '';
            };
          };
          operators = {};
          splitjoin = {};
        };
      };

      nvim-colorizer = {
        enable = true;
        bufTypes = [
          "css"
          "scss"
          "typescript"
          "typescriptreact"
          "javascript"
          "javascriptreact"
          "html"
        ];
      };
    };

    extraConfigLua = ''
      require('template-string').setup({
        remove_template_string = true,
        restore_quotes = {
          normal = [["]],
          jsx = [[']],
        }
      })
    '';
  };
}
