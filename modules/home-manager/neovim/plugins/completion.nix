let
  icons = import ../icons.nix;
in {
  programs.nixvim = {
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        experimental = {
          ghost_text = true;
          # ghost_text = {
          #   hl_group = "CmpGhostText";
          # };
        };

        completion.completeopt = "menu,menuone,noselect";

        sources = [
          {
            name = "nvim_lsp";
            priority = 10;
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 9;
          }
          {
            name = "buffer";
            priority = 8;
          }
          {
            name = "path";
            priority = 6;
          }
          {
            name = "emoji";
            priority = 5;
          }
        ];

        formatting = {
          fields = ["kind" "abbr" "menu"];
          format = ''
            function(entry, item)
              if icons_kind[item.kind] then
                item.kind = icons_kind[item.kind] .. item.kind
              end
              item.menu = format_menu[entry.source.name]

              local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
              if completion_context ~= nil and completion_context ~= "" then
                item.menu = item.menu .. " ・" .. completion_context
              end

              return item
            end
          '';
        };

        snippet = {
          expand = ''
            function(args)
              require('snippy').expand_snippet(args.body)
            end
          '';
        };

        preselect = "cmp.PreselectMode.None";

        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
              ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-u>"] = cmp.mapping.scroll_docs(4),
              ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
                end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end, { "i", "s" }),
            })
          '';
        };

        window = {
          completion = {
            border = "single";
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel";
          };
          documentation = {
            border = "single";
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel";
          };
        };

        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
      };

      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = {
            __raw = ''
              {
                { name = "nvim_lsp_document_symbol" },
              },
              {
                { name = "buffer" },
              }
            '';
          };
        };
        "?" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = {
            __raw = ''
              {
                { name = "nvim_lsp_document_symbol" },
              },
              {
                { name = "buffer" },
              }
            '';
          };
        };
        ":" = {
          sources = {
            __raw = ''
              {
                { name = 'path' }
              },
              {
                { name = 'cmdline' }
              }
            '';
          };
        };

        filetype = {
          "gitcommit" = {
            sources = {
              __raw = ''
                {
                  { name = 'cmp_git' },
                },
                {
                  { name = 'buffer' },
                }
              '';
            };
          };
        };

        # experimental = {
        #   experimental = {
        #     ghost_text = true;
        #   };
        #   # ghost_text = {
        #   #   hl_group = "CmpGhostText";
        #   # };
        # };

        # preselect = "None";

        # mappingPresets = ["insert" "cmdline"];
      };
    };

    extraConfigLuaPre = ''
      local icons_kind = {
        Array = "${icons.kinds.Array}",
        Boolean = "${icons.kinds.Boolean}",
        Class = "${icons.kinds.Class}",
        Color = "${icons.kinds.Color}",
        Constant = "${icons.kinds.Constant}",
        Constructor = "${icons.kinds.Constructor}",
        Copilot = "${icons.kinds.Copilot}",
        Enum = "${icons.kinds.Enum}",
        EnumMember = "${icons.kinds.EnumMember}",
        Event = "${icons.kinds.Event}",
        Field = "${icons.kinds.Field}",
        File = "${icons.kinds.File}",
        Folder = "${icons.kinds.Folder}",
        Function = "${icons.kinds.Function}",
        Interface = "${icons.kinds.Interface}",
        Key = "${icons.kinds.Key}",
        Keyword = "${icons.kinds.Keyword}",
        Method = "${icons.kinds.Method}",
        Module = "${icons.kinds.Module}",
        Namespace = "${icons.kinds.Namespace}",
        Null = "${icons.kinds.Null}",
        Number = "${icons.kinds.Number}",
        Object = "${icons.kinds.Object}",
        Operator = "${icons.kinds.Operator}",
        Package = "${icons.kinds.Package}",
        Property = "${icons.kinds.Property}",
        Reference = "${icons.kinds.Reference}",
        Snippet = "${icons.kinds.Snippet}",
        String = "${icons.kinds.String}",
        Struct = "${icons.kinds.Struct}",
        Text = "${icons.kinds.Text}",
        TypeParameter = "${icons.kinds.TypeParameter}",
        Unit = "${icons.kinds.Unit}",
        Value = "${icons.kinds.Value}",
        Variable = "${icons.kinds.Variable}",
      }

      local format_menu = {
        buffer = "BUFFER",
        nvim_lsp = "LSP",
        path = "PATH",
        snippy = "SNIPPET",
        emoji = "EMOJI",
        copilot = " ",
      }

      local function get_lsp_completion_context(completion, source)
        local ok, source_name = pcall(function()
          return source.source.client.config.name
        end)
        if not ok then
          return nil
        end
        return completion and completion.detail or nil
        -- if source_name == "typescript-tools" then
        --   return completion.detail
        -- end
      end

      local has_words_before = function()
        -- if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
    '';

    plugins = {
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      cmp-emoji.enable = true;
      cmp-cmdline.enable = true;
      cmp-git.enable = true;
      cmp-snippy.enable = true;
    };
  };
}
