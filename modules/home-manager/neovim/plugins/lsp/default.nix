{
  imports = [
    ./diagnostics.nix

    ./servers/typescript-tools.nix
    ./servers/eslint.nix
    ./servers/gopls.nix
    ./servers/dockerls.nix
    ./servers/graphql.nix
  ];

  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gK = "signature_help";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          lr = "rename";
          ca = "code_action";
        };
      };

      onAttach = ''
        lsp_attach_custom(client, bufnr);
      '';

      servers = {
        bashls.enable = true;
        cssls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua-ls = {
          enable = true;
          settings = {
            telemetry.enable = false;
          };
        };
        nil_ls = {
          enable = true;
          settings.formatting.command = ["alejandra"];
        };
        nixd = {
          enable = true;
          settings.formatting.command = "alejandra";
        };
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };

    plugins.fidget.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>cd";
        action = "vim.diagnostic.open_float";
        lua = true;
        options = {desc = "Open diagnostics in floating window";};
      }
      {
        mode = "n";
        key = "<leader>uh";
        action = ''
          function()
            if (vim.lsp.inlay_hint ~= nil) then
            	vim.lsp.inlay_hint(0, nil)
            end
          end
        '';
        lua = true;
        options = {desc = "Toggle inlay hints";};
      }
    ];

    extraConfigLuaPre = ''
      require('lspconfig.ui.windows').default_options = {
        border = "rounded"
      }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
      })

      local diagnostics_float_config = {
      	focusable = false,
      	close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      	border = "rounded",
      	source = "always",
      	prefix = " ",
      	scope = "cursor",
      }

      local function diagnostics_float_handler()
      	-- Immediately return if the screen width can show virtual text
      	-- Mostly done for window splits and termux
      	if vim.fn.winwidth(0) > 100 then
      		return
      	end

      	local cword = vim.fn.expand("<cword>")
      	if cword ~= vim.w.lsp_diagnostics_cword then
      		vim.w.lsp_diagnostics_cword = cword

      		local _, winnr = vim.diagnostic.open_float(diagnostics_float_config)
      		if winnr ~= nil then
      			vim.api.nvim_win_set_option(winnr, "winblend", 20)
      		end
      	end
      end

      local lsp_attach_custom_group = vim.api.nvim_create_augroup("LspCustomAutocmds", { clear = true })

      local lsp_attach_custom = function(client, bufnr)

        -- Show diagnostic in floating window on smaller windows
      	vim.api.nvim_create_autocmd("CursorHold", {
      		group = lsp_attach_custom_group,
      		buffer = bufnr,
      		callback = diagnostics_float_handler,
      		desc = "Shows diagnostic in floating window on smaller windows",
      	})

        -- Highlight symbol under cursor
      	if client.server_capabilities.documentHighlightProvider then
      		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      			group = lsp_attach_custom_group,
      			buffer = bufnr,
      			callback = vim.lsp.buf.document_highlight,
      			desc = "Highlights symbol under cursor",
      		})

      		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      			group = lsp_attach_custom_group,
      			buffer = bufnr,
      			callback = vim.lsp.buf.clear_references,
      			desc = "Clears symbol highlighting under cursor",
      		})
      	end

        -- Disable inlay hints by default. Can be toggle if needed
        local inlay_hint = vim.lsp.buf.inlay_hints or vim.lsp.inlay_hints
          if inlay_hint and client.supports_method("textDocument/inlayHint") then
          inlay_hint(bufnr, false)
        end
      end
    '';
  };
}
