{
  programs.nixvim = {
    keymaps = [
      ### Better up/down
      {
        mode = ["n" "x"];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          silent = true;
          expr = true;
        };
      }
      {
        mode = ["n" "x"];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          silent = true;
          expr = true;
        };
      }

      ### Move window using <ctrl> keys
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          desc = "Go to left window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Go to lower window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          desc = "Go to upper window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Go to right window";
          remap = true;
        };
      }

      ### Open buffer in new tab (aka Maximize)
      {
        mode = "n";
        key = "<C-W>m";
        action = "<C-W>s<C-W>T";
        options = {desc = "Open buffer in new tab (maximize)";};
      }

      ### Resize window using <ctrl> arrow keys
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options = {desc = "Increase window height";};
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options = {desc = "Decrease window height";};
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {desc = "Decrease window width";};
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {desc = "Increase window width";};
      }

      ### Move lines
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options = {desc = "Move line(s) down";};
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options = {desc = "Move line(s) up";};
      }
      {
        mode = "i";
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options = {desc = "Move line(s) down";};
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options = {desc = "Move line(s) up";};
      }

      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options = {desc = "Move line(s) down";};
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options = {desc = "Move line(s) up";};
      }

      ### Clear search with <esc>
      {
        mode = ["i" "n"];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {desc = "Escape and clear hlsearch";};
      }

      ### Maintain the cursor position when yanking a visual selection
      ### http://ddrscott.github.io/blog/2016/yank-without-jank/
      {
        mode = "v";
        key = "y";
        action = "myy`y";
      }
      {
        mode = "v";
        key = "Y";
        action = "myY`y";
      }

      ### Better indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      ### No copy
      {
        mode = "x";
        key = "<leader>p";
        action = "[[\"_dP]]";
        options = {desc = "Past without copy";};
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "[[\"+y]]";
        options = {desc = "Yank without copy";};
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "[[\"+Y]]";
        options = {desc = "Yank without copy";};
      }
      {
        mode = ["n" "v"];
        key = "<leader>d";
        action = "[[\"_d]]";
        options = {desc = "Delete without copy";};
      }
      {
        mode = ["n" "v"];
        key = "x";
        action = "'\"_x'";
        options = {desc = "Delete character without copy";};
      }
      {
        mode = "n";
        key = "dd";
        action = ''
          function()
          	if vim.api.nvim_get_current_line():match("^%s*$") then
          		return [["_dd]]
          	else
          		return [[dd]]
          	end
          end
        '';
        lua = true;
        options = {
          expr = true;
          desc = "Delete line without yank empty line";
        };
      }

      ### Keeping it centered
      {
        mode = "n";
        key = "G";
        action = "Gzz";
      }
      {
        mode = "n";
        key = "<C-f>";
        action = "<C-f>zz";
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "<C-b>";
        action = "<C-b>zz";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nlzzzv";
      }

      ### Tabs
      {
        mode = "n";
        key = "[t";
        action = "<cmd>tabprevious<cr>";
        options = {desc = "Previous tab";};
      }
      {
        mode = "n";
        key = "]t";
        action = "<cmd>tabnext<cr>";
        options = {desc = "Next tab";};
      }

      ### Inspect UI
      {
        mode = "n";
        key = "<leader>ui";
        action = "vim.show_pos";
        lua = true;
        options = {desc = "Inspect position";};
      }
    ];
  };
}
