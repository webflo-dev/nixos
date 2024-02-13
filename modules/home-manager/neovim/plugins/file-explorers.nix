let
  icons = import ../icons.nix;
in {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      sourceSelector = {
        sources = [
          {source = "filesystem";}
        ];
      };

      filesystem = {
        bindToCwd = false;
        useLibuvFileWatcher = true;
        # hijackNetrwBehavior = "disabled";
        followCurrentFile.enabled = true;
        window.mappings = {
          "<Right>" = "open";
          "<Left>" = "close_node";
          "l" = "open";
          "h" = "close_node";
        };
      };

      defaultComponentConfigs = {
        gitStatus.symbols = {
          added = icons.git.added;
          deleted = icons.git.removed;
          modified = icons.git.modified;
          renamed = icons.git.renamed;
          untracked = icons.git.untracked;
          ignored = icons.git.ignored;
          unstaged = icons.git.untracked;
          staged = icons.git.staged;
          conflict = icons.git.conflict;
        };
        diagnostics.symbols = {
          error = icons.diagnostics.error;
          hint = icons.diagnostics.hint;
          info = icons.diagnostics.info;
          warn = icons.diagnostics.warn;
        };
        indent = {
          expanderCollapsed = icons.common.collapsed;
          expanderExpanded = icons.common.expanded;
          withExpanders = true;
        };
      };

      window = {
        # position = "float";
        popup = {
          size = {
            height = "60%";
            width = "40%";
          };
          # position = "20%";
        };
        mappings = {
          "<C-s>" = "open_split";
          "<C-v>" = "open_vsplit";
          "<C-t>" = "open_tabnew";
          "a" = {
            command = "add";
            config = {
              show_path = "relative";
            };
          };
          "m" = {
            command = "m";
            config = {
              show_path = "relative";
            };
          };
          "c" = {
            command = "copy";
            config = {
              show_path = "relative";
            };
          };
        };
      };

      eventHandlers = {
        "file_opened" = ''
          function()
            --auto close
          	require("neo-tree.command").execute({ action = "close" })
          end
        '';

        "before_file_move" = ''
          function(data)
            lsp_rename_file(data.source, data.destination)
          end
        '';

        "before_file_rename" = ''
          function(data)
            lsp_rename_file(data.source, data.destination)
          end,
        '';
      };
    };

    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle reveal=true<cr>";
        options = {
          desc = "Toggle Neotree";
        };
      }
    ];

    extraConfigLuaPre = ''
      local lsp_rename_file = function(source, newSource)
        local a = require("plenary.async")
        local async = require("typescript-tools.async")
        local c = require("typescript-tools.protocol.constants")
        local uv = require("plenary.async.uv_async")
        local au = require("plenary.async.util")

        a.void(function()
          if not newSource then
            return
          end

          local err, result = async.buf_request_isomorphic(true, 0, c.LspMethods.WillRenameFiles, {
            files = {
              {
                oldUri = vim.uri_from_fname(source),
                newUri = vim.uri_from_fname(newSource),
              },
            },
          })

          local changes = result and result.changes
          if not err and changes then
            local fs_err = uv.fs_stat(newSource)
            if not fs_err then
              au.scheduler()
              vim.notify_once("[typescript-tools] Cannot rename to exitsting file!", vim.log.levels.ERROR)
              return
            end

            fs_err = uv.fs_rename(source, newSource)
            assert(not fs_err, fs_err)

            au.scheduler()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == source then
                vim.api.nvim_buf_set_name(bufnr, newSource)
              end
            end

            vim.lsp.util.apply_workspace_edit(result or {}, "utf-8")
          end
        end)()
      end
    '';
  };
}
