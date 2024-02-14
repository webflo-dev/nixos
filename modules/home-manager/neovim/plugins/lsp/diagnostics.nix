let
  icons = import ../../icons.nix;
in {
  programs.nixvim = {
    extraConfigLua = ''
      vim.fn.sign_define("DiagnosticSignError", { text = "${icons.diagnostics.error}", texthl = "DiagnosticSignError", numhl = "" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = "${icons.diagnostics.warn}", texthl = "DiagnosticSignWarn", numhl = "" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "${icons.diagnostics.hint}", texthl = "DiagnosticSignHint", numhl = "" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = "${icons.diagnostics.info}", texthl = "DiagnosticSignInfo", numhl = "" })

      vim.diagnostic.config({
      	underline = true,
      	-- underline = {
      	-- 	severity = { min = vim.diagnostic.severity.WARN },
      	-- },
      	update_in_insert = false,
      	virtual_text = {
      		only_current_line = false,
      		spacing = 4,
      		prefix = "■",
      		-- prefix = function(diagnostic)
      		-- 	local icons = require("icons").diagnostics
      		-- 	for d, icon in pairs(icons) do
      		-- 		if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
      		-- 			return icon
      		-- 		end
      		-- 	end
      		-- end,
      		source = "if_many",
      	},
      	severity_sort = true,
      	signs = true,
      	float = {
      		focusable = false,
      		-- style = "minimal",
      		border = "rounded",
      		scope = "line",
      		source = "always",
      		header = "",
      		prefix = "",
      	},
      })


    '';
  };
}
