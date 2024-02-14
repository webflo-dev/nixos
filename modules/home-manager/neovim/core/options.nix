{
  programs.nixvim = {
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
      # fillchars = ["eob:" "fold:" "foldopen:" "foldsep:" "foldclose:"];
      fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";
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
  };
}
