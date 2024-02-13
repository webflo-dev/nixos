{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      typescript-tools-nvim
      plenary-nvim
      nvim-lspconfig
    ];

    plugins.lsp.postConfig = ''
      require('typescript-tools').setup({
      	on_attach = function(client, bufnr)
      		client.server_capabilities.documentFormattingProvider = false
      		client.server_capabilities.documentRangeFormattingProvider = false
      		lsp_attach_custom(client, bufnr)
      	end,
      	settings = {
      		tsserver_max_memory = 1024,
      		separate_diagnostic_server = true,
      		code_lens = "off", -- implementations_only, references_only, off, all
      		disable_member_code_lens = false,
      		complete_function_calls = true,
      		publish_diagnostic_on = "insert_leave", -- insert_leave, change

      		-- fix_all, add_missing_imports, remove_unused, remove_unused_imports, organize_imports
      		-- expose_as_code_action = "all",
      		-- expose_as_code_action = {
      		-- 	"fix_all",
      		-- 	"add_missing_imports",
      		-- 	"remove_unused",
      		-- },
      		tsserver_file_preferences = {
      			includeInlayParameterNameHints = "literals",
      			-- includeInlayParameterNameHints = 'all',
      			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      			includeInlayFunctionParameterTypeHints = true,
      			includeInlayVariableTypeHints = true,
      			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      			includeInlayPropertyDeclarationTypeHints = true,
      			includeInlayFunctionLikeReturnTypeHints = true,
      			includeInlayEnumMemberValueHints = true,
      		},
      	},
      })
    '';
  };
}
