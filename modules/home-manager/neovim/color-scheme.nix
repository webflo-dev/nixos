{
  programs.nixvim = {
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
      dimInactive = true;
      transparent = true;
      styles = {
        floats = "transparent";
        sidebars = "transparent";
      };

      onHighlights = ''
        function(highlights, colors)
        	highlights.CursorLine = {
        		bg = "#143652",
        	}

        	highlights.Search = {
        		bg = "#0A64AC",
        	}

        	highlights.CursorLineNr = {
        		fg = "#FFFFFF",
        	}

        	highlights.LineNr = {
        		fg = colors.dark5,
        	}

        	highlights.TreesitterContextLineNumber = {
        		fg = highlights.CursorLineNr.fg,
        	}

        	highlights.WinSeparator = {
        		bold = true,
        		fg = colors.fg_gutter,
        		-- fg = "#FFFFFF",
        	}

        	highlights.VertSplit = {
        		fg = "#FFFFFF",
        	}
        end
      '';
    };

    extraConfigLuaPost = "vim.cmd.colorscheme('tokyonight-moon')";
  };
}
