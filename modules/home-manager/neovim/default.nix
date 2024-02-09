{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.neovim;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.webflo.modules.neovim = {
    enable = mkEnableOption "neovim";
    useAsManPager = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # programs.neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    #   vimdiffAlias = true;
    # };

    home.sessionVariables = mkIf cfg.useAsManPager {
      MANPAGER = "nvim +Man!";
    };

    programs.nixvim = {
      enable = true;
      colorschemes.tokyonight.enable = true;

      globals.mapleader = " ";
      globals.maplocalleader = " ";

      options = {
        autoindent = true; # Good auto indent
        autowrite = true; # Enable auto write
        backup = false; # automatically save a backup file
        backspace = "indent,eol,start"; # Making sure backspace works
        breakindent = true; # maintain indent when wrapping indented lines
        clipboard = "unnamed,unnamedplus"; # Copy-paste between vim and everything else
        cmdheight = 1; # Give more space for displaying messages
        completeopt = "menu,menuone,noselect,longest,preview"; # Better autocompletion
        conceallevel = 0; # Show `` in markdown files
        confirm = true; # Confirm to save changes before exiting modified buffer
        cursorline = true; # Enable highlighting of the current line
        #### dir = vim.fn.stdpath("data") .. "/swp"               ; # swap file directory
        emoji = false; # Fix emoji display
        encoding = "utf-8"; # The encoding displayed
        errorbells = false; # Disables sound effect for errors
        expandtab = true; # Use spaces instead of tabs
        # fileencoding = "utf-8"; # The encoding written to file
        fillchars = ["eob:" "fold:" "foldopen:" "foldsep:" "foldclose:"];
        # fillchars = {
        #   horiz = '━',
        #   horizup = '┻',
        #   horizdown = '┳',
        #   vert = '┃',
        #   vertleft = '┫',
        #   vertright = '┣',
        #   verthoriz = '╋',
        # }
        foldcolumn = "0";
        foldlevel = 99; # Using ufo provider need a large value
        foldlevelstart = 99; # Expand all folds by default
        foldnestmax = 0;
        formatoptions = "jcqlnt";
        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";
        hidden = true; # Enable modified buffers in background
        history = 500; # Use the 'history' option to set the number of lines from command mode that are remembered.
        hlsearch = true;
        ignorecase = true; # Needed for smartcase
        incsearch = true; # Start searching before p:wqressing enter
        inccommand = "nosplit"; # preview incremental substitute
        laststatus = 2;
        # lazyredraw = true; # Makes macros faster & prevent errors in complicated mappings
        list = false; # Show some invisible characters (tabs...
        listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<";
        # listchars = "tab:>·,trail:~,extends:>,precedes:<"
        matchpairs = ["(:)" "{:}" "[:]" "<:>"];
        mouse = "a"; # Enable mouse
        number = true; # Shows current line number
        pumblend = 10; # Popup blend
        pumheight = 10; # Max num of items in completion menu
        redrawtime = 10000; # Allow more time for loading syntax on large files
        relativenumber = true; # Enables relative number
        scrolloff = 8; # Always keep space when scrolling to bottom/top edge
        # sessionoptions = { "buffers", "curdir", "tabpages", "winsize" };
        shiftround = true; # Round indent
        shiftwidth = 2; # Change a number of space characeters inseted for indentation
        showmode = false; # Dont show mode since we have a statusline
        showtabline = 1; # show tabs if more than one (2 = always, 0 = hide)
        sidescrolloff = 8;
        signcolumn = "yes:3"; # Add extra sign column next to line number
        smartcase = true; # Uses case in search
        smartindent = true; # Makes indenting smart
        smarttab = true; # Makes tabbing smarter will realize you have 2 vs 4
        softtabstop = 2; # Insert 2 spaces for a tab
        spell = false;
        # spelllang = { "en" };
        splitbelow = true; # Put new windows below current
        splitright = true; # Put new windows right of current
        # vim.o.statuscolumn =
        # '%=%l%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : "  " }%*'
        # statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
        swapfile = false; # Swap not needed
        tabstop = 2; # Insert 2 spaces for a tab
        termguicolors = true; # True color support
        timeout = true;
        timeoutlen = 300; # Faster completion (cannot be lower than 200 because then commenting doesn't work)
        ttimeoutlen = 0; # Time in milliseconds to wait for a key code sequence to complete
        title = true;
        # undodir = vim.fn.stdpath("data") .. "/undodir"; # set undo directory
        undofile = true; # Sets undo to file
        undolevels = 1000;
        updatetime = 200; # Faster completion
        viminfo = "'1000"; # Increase the size of file history

        wildignorecase = true; # When set case is ignored when completing file names and directories
        wildmode = "longest:full,full"; # complete the longest common match and allow tabbing the results to fully complete them
        winminwidth = 5; # Minimum window width
        wrap = false; # Display long lines as just one line
        writebackup = false; # Not needed

        # vim.opt.backupdir:remove(".")          # keep backups out of the current directory
        # vim.opt.shortmess:append("WI")
      };

      autoCmd = [
        # {
        #   event = ["BufEnter" "BufWinEnter"];
        #   pattern = [".c" ".h"];
        #   callback = {__raw = "function() print(‘This buffer enters’) end";};
        # }
        {
          desc = "Highlight yanked text";
          event = ["TextYankPost"];
          callback.__raw = ''
            function()
              vim.highlight.on_yank();
              return true;
            end
          '';
        }
        {
          desc = "Resize splits if window got resized";
          event = ["VimResized"];
          callback.__raw = ''
            function()
              vim.cmd('tabdo wincmd =');
              return true;
            end
          '';
        }
        # {
        #   desc = "Go to last position when opening a file";
        #   event = ["BufReadPost"];
        #   callback._raw = ''
        #     function()
        #       local mark = vim.api.nvim_buf_get_mark(0, '"')
        #       local lcount = vim.api.nvim_buf_line_count(0)
        #       if mark[1] > 0 and mark[1] <= lcount then
        #         pcall(vim.api.nvim_win_set_cursor, 0, mark)
        #       end
        #       return true
        #     end
        #   '';
        # }
        {
          desc = "Close some filetypes with <q>";
          event = ["FileType"];
          pattern = [
            "PlenaryTestPopup"
            "checkhealth"
            "copilot.*"
            "gitsigns"
            "help"
            "lspinfo"
            "man"
            "neotest-output"
            "neotest-output-panel"
            "neotest-summary"
            "notify"
            "octo"
            "qf"
            "query"
            "spectre_panel"
            "startuptime"
            "tsplayground"
          ];
          callback.__raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, noremap = true })
              return true
            end
          '';
        }
        {
          desc = "Set options for terminal buffer";
          event = ["TermOpen"];
          callback.__raw = ''
            function()
              vim.cmd([[
                setlocal nonu
                setlocal nornu
                setlocal nolist
                setlocal signcolumn=no
                setlocal foldcolumn=0
                setlocal statuscolumn=
                setlocal nocursorline
                setlocal scrolloff=0
                startinsert
              ]])
              return true
            end
          '';
        }
        {
          desc = "Set borders to few floating windows";
          event = ["FileType"];
          pattern = ["lspinfo"];
          callback.__raw = ''
            function()
              vim.api.nvim_win_set_config(0, { border = "rounded" })
              return true
            end
          '';
        }
        {
          desc = "Disable conceal for JSON files";
          event = ["FileType"];
          pattern = ["json" "jsonc"];
          callback.__raw = ''
            function()
              vim.wo.conceallevel = 0
              return true
            end
          '';
        }
        {
          desc = "Disable cursorline when leaving buffer";
          event = ["BufLeave"];
          pattern = ["*"];
          callback.__raw = ''
            function()
              vim.wo.cursorline = false
              return true
            end
          '';
        }
        {
          desc = "Enable cursorline when entering buffer";
          event = ["WinEnter" "BufWinEnter"];
          pattern = ["*"];
          callback.__raw = ''
            function()
              vim.wo.cursorline = true
              return true
            end
          '';
        }
      ];

      filetype = {
        extension = {
          eslintrc = "jsonc";
          mdx = "markdown";
          prettierrc = "json";
        };
        filename = {
          ".eslintrc.json" = "jsonc";
        };
        pattern = {
          ".env" = "sh";
          ".*%.env.*" = "sh";
          "tsconfig.json" = "jsonc";
          "tsconfig.*.json" = "jsonc";
        };
      };

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
        # {
        #   mode = "n";
        #   key = "dd";
        #   action.__raw = ''
        #     function()
        #     	if vim.api.nvim_get_current_line():match("^%s*$") then
        #     		return [["_dd]]
        #     	else
        #     		return [[dd]]
        #     	end
        #   '';
        #   options = {
        #     expr = true;
        #     desc = "Delete line without yank empty line";
        #   };
        # }

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
          action.__raw = "vim.show_pos";
          options = {desc = "Inspect position";};
        }
      ];
    };
  };
}
