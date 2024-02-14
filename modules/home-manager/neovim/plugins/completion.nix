let
  icons = import ../icons.nix;
in {
  programs.nixvim = {
    plugins.nvim-cmp = {
      enable = true;

      experimental = {
        experimental = {
          ghost_text = true;
        };
        # ghost_text = {
        #   hl_group = "CmpGhostText";
        # };
      };

      performance = {
        debounce = 60;
        fetchingTimeout = 200;
        maxViewEntries = 30;
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

      # completion.completeopt = "menu,menuone,noinsert";
      completion.completeopt = "menu,menuone,noselect";
      preselect = "None";

      # snippet = {
      #   expand = {
      #     __raw = ''
      #       function(args)
      #        vim.snippet.expand(args.body)
      #       end
      #     '';
      #   };
      # };
      snippet.expand = "snippy";

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

      mappingPresets = ["insert" "cmdline"];

      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
        "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-u>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = true; behavior = cmp.ConfirmBehavior.Replace; })";
        # "<Tab>" = {
        #   action = "cmp.mapping.select_next_item()";
        #   modes = ["i" "s"];
        # };
        # "<S-Tab>" = {
        #   action = "cmp.mapping.select_prev_item()";
        #   modes = ["i" "s"];
        # };
        # "<Tab>" = {
        #   action = ''
        #     cmp.mapping(function(fallback)
        #     	if cmp.visible() then
        #     		cmp.select_next_item()
        #     	elseif has_words_before() then
        #     		cmp.complete()
        #     	else
        #     		fallback()
        #     	end
        #     end)
        #   '';
        #   modes = ["i" "s"];
        # };
        # "<S-Tab>" = {
        #   action = ''
        #     cmp.mapping(function(fallback)
        #       if cmp.visible() then
        #         cmp.select_prev_item()
        #       else
        #         fallback()
        #       end
        #     end)
        #   '';
        #   modes = ["i" "s"];
        # };
      };

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
    };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-nvim-lsp-document-symbol.enable = true;
    plugins.cmp-nvim-lsp-signature-help.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-emoji.enable = true;
    plugins.cmp-cmdline.enable = true;
    plugins.cmp-git.enable = true;

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
    '';

    extraConfigLua = ''
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
      })

    '';
  };
}
