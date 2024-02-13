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
      nvim-spectre
    ];

    plugins = {
      hardtime.enable = false;

      which-key = {
        enable = false;
        plugins.spelling.enabled = false;
      };

      trouble = {
        enable = true;
        useDiagnosticSigns = true;
      };

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

      copilot-lua = {
        enable = true;
        panel = {
          enabled = false;
          autoRefresh = true;
          keymap = {
            jumpPrev = "[[";
            jumpNext = "]]";
            accept = "<CR>";
            refresh = "gr";
            open = "<C-CR>";
          };
          layout = {
            position = "right";
            ratio = 0.4;
          };
        };
        suggestion = {
          enabled = true;
          autoTrigger = true;
          keymap = {
            accept = "<M-a>";
            acceptWord = "<M-w>";
            acceptLine = "<M-l>";
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        filetypes = {
          javascript = true;
          typescript = true;
          css = true;
          yaml = false;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          terraform = false;
          sh.__raw = ''
            function()
              if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)) or "", '^%.env.*') then
                -- disable for .env files
                return false
              end
              return true
            end
          '';
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>TroubleToggle document_diagnostics<cr>";
        options = {desc = "Document diagnostics (Trouble)";};
      }
      {
        mode = "n";
        key = "<leader>xw";
        action = "<cmd>TroubleToggle workspace_diagnostics<cr>";
        options = {desc = "Workspace diagnostics (Trouble)";};
      }
      {
        mode = "n";
        key = "<leader>xl";
        action = "<cmd>TroubleToggle loclist<cr>";
        options = {desc = "Location list (Trouble)";};
      }
      {
        mode = "n";
        key = "<leader>xq";
        action = "<cmd>TroubleToggle quickfix<cr>";
        options = {desc = "Quickfix list (Trouble)";};
      }
      {
        mode = "n";
        key = "[q";
        action = ''
          function()
            if require("trouble").is_open() then
              require("trouble").previous({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
        lua = true;
        options = {desc = "Previous item (Trouble)";};
      }
      {
        mode = "n";
        key = "]q";
        action = ''
          function()
            if require("trouble").is_open() then
              require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
        lua = true;
        options = {desc = "Next item (Trouble)";};
      }

      {
        mode = "n";
        key = "<leader>S";
        action = "<cmd>lua require('spectre').toggle()<cr>";
        options = {desc = "Search & replace in files (Spectre)";};
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = "<cmd>lua require('spectre').open_visual({ select_word = true })<cr>";
        options = {desc = "Search current word (Spectre)";};
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>";
        options = {desc = "Search on current file (Spectre)";};
      }
    ];

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
