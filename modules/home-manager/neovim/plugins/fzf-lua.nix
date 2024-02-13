{pkgs, ...}: let
  icons = import ../icons.nix;
  package = pkgs.vimPlugins.fzf-lua;
  keymap = key: action: desc: {
    mode = "n";
    key = "<leader>${key}";
    action = "<cmd>FzfLua ${action}<cr>";
    options = {desc = desc;};
  };
in {
  programs.nixvim = {
    extraPlugins = [package];

    keymaps = [
      (keymap "/" "live_grep_glob resume=true" "Find in files (grep)")
      (keymap "," "buffers" "Show buffers")
      (keymap ":" "command_history" "Command history")
      (keymap "f" "files" "Find files")
      (keymap "F" "resume" "FzfLua resume")
      (keymap "fg" "live_grep_glob resume=true" "Grep")
      (keymap "r" "oldfiles" "Recently opened files")
      (keymap "w" "grep_cword" "Search word under cursor")
      (keymap "gc" "git_commits" "Git commits")
      (keymap "gb" "git_branches" "Git branches")
      (keymap "gs" "git_status" "Git status")
      (keymap "gS" "git_stash" "Git stash")
      (keymap "gC" "git_bcommits" "Git branch commits")
    ];

    extraConfigLua = ''
      local function hl_validate(hl)
        return not require("fzf-lua.utils").is_hl_cleared(hl) and hl or nil
      end

      require('fzf-lua').setup({
        winopts = {
          height = 0.7,
          width = 0.8,
          preview = {
            hidden = "nohidden",
            scrollbar = false,
          },
          hl = {
            normal = hl_validate("TelescopeNormal"),
            border = hl_validate("TelescopeBorder"),
            help_normal = hl_validate("TelescopeNormal"),
            help_border = hl_validate("TelescopeBorder"),
            -- builtin preview only
            cursor = hl_validate("Cursor"),
            cursorline = hl_validate("TelescopePreviewLine"),
            cursorlinenr = hl_validate("TelescopePreviewLine"),
            search = hl_validate("IncSearch"),
            title = hl_validate("TelescopeTitle"),
          }
        },
        fzf_colors = {
          ["fg"] = { "fg", "TelescopeNormal" },
          ["bg"] = { "bg", "TelescopeNormal" },
          ["hl"] = { "fg", "TelescopeMatching" },
          ["fg+"] = { "fg", "TelescopeSelection" },
          ["bg+"] = { "bg", "TelescopeSelection" },
          ["hl+"] = { "fg", "TelescopeMatching" },
          ["info"] = { "fg", "TelescopeMultiSelection" },
          ["border"] = { "fg", "TelescopeBorder" },
          ["gutter"] = { "bg", "TelescopeNormal" },
          ["prompt"] = { "fg", "TelescopePromptPrefix" },
          ["pointer"] = { "fg", "TelescopeSelectionCaret" },
          ["marker"] = { "fg", "TelescopeSelectionCaret" },
          ["header"] = { "fg", "TelescopeTitle" },
        },
        files = {
          prompt = "Files ${icons.common.prompt}",
        },
        buffers = {
          keymap = {
            builtin = {
              ["<C-d>"] = false
            }
          },
          actions = {
            ["ctrl-x"] = false,
            ["ctrl-d"] = { require("fzf-lua.actions").buf_del, require("fzf-lua.actions").resume },
            -- ["ctrl-D"] = { close_all_buffers, require("fzf-lua.actions").resume }
          },
          -- fzf_opts = {
          --   ["--header"] = buffers_header()
          -- },
        },
        grep = {
          header_prefix = '${icons.common.search} ',
        },
        lsp = {
          symbols = {
            symbol_icons = icons_kind,
          },
        },
        colorschemes = {
          -- winopts = { height = 0.33, width = 0.33, },
          winopts = { height = 0.33, width = 0.20 },
        },
      })

      require('fzf-lua').register_ui_select()
    '';
  };
}
