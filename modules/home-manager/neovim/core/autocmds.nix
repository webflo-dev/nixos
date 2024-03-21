{
  programs.nixvim = {
    autoCmd = [
      {
        desc = "Highlight yanked text";
        event = ["TextYankPost"];
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
            return true
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
      {
        desc = "Go to last position when opening a file";
        event = ["BufReadPost"];
        callback.__raw = ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
            return true
          end
        '';
      }
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
  };
}
