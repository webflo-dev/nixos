let
  icons = import ../icons.nix;
in {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;

      popupBorderStyle = "rounded";
      closeIfLastWindow = true;

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
        findArgs = {
          fd = [
            "--exclude"
            ".git"
            "--exclude"
            "node_modules"
          ];
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
          "D" = {
            command.__raw = ''
              function(state)
                local node = state.tree:get_node()
                local log = require("neo-tree.log")
                state.clipboard = state.clipboard or {}
                if diff_Node and diff_Node ~= tostring(node.id) then
                  local current_Diff = node.id
                  require("neo-tree.utils").open_file(state, diff_Node, open)
                  vim.cmd("vert diffs " .. current_Diff)
                  log.info("Diffing " .. diff_Name .. " against " .. node.name)
                  diff_Node = nil
                  current_Diff = nil
                  state.clipboard = {}
                  require("neo-tree.ui.renderer").redraw(state)
                else
                  local existing = state.clipboard[node.id]
                  if existing and existing.action == "diff" then
                    state.clipboard[node.id] = nil
                    diff_Node = nil
                    require("neo-tree.ui.renderer").redraw(state)
                  else
                    state.clipboard[node.id] = { action = "diff", node = node }
                    diff_Name = state.clipboard[node.id].node.name
                    diff_Node = tostring(state.clipboard[node.id].node.id)
                    log.info("Diff source file " .. diff_Name)
                    require("neo-tree.ui.renderer").redraw(state)
                  end
                end
              end
            '';
          };
          "I" = {
            command.__raw = ''
              function(state)
                local node = state.tree:get_node()
                print(vim.inspect(node))
                state.clipboard[node.id] = { action = "copy", node = node }
              end
            '';
          };
          "a" = {
            command = "add";
            config = {
              show_path = "relative";
            };
          };
          # "m" = {
          #   command = "m";
          #   config = {
          #     show_path = "relative";
          #   };
          # };
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
            lsp_rename_custom(data.source, data.destination)
          end
        '';

        "before_file_rename" = ''
          function(data)
            lsp_rename_custom(data.source, data.destination)
          end
        '';

        ## Hide cursor when neotree is open
        "neo_tree_buffer_enter" = ''
          function()
            vim.cmd("highlight! Cursor blend=100")
          end
        '';
        ## Show cursor when neotree is leave
        "neo_tree_buffer_leave" = ''
          function()
            vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
          end
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
      local lsp_rename_custom = function(source, newSource)
        local a = require "plenary.async"
        local uv = require "plenary.async.uv_async"
        local au = require "plenary.async.util"
        local c = require "typescript-tools.protocol.constants"
        local async = require "typescript-tools.async"

        a.void(function()
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
