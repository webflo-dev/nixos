{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.modules.zsh = {
    enable = mkEnableOption "ZSH module";
  };

  config = mkIf cfg.enable {
    
    programs.zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
        strategy = [ "history" "completion" ];
        extraConfig = {
          ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "50";
        };
      };
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        patterns = { 
          "rm -rf *" = "fg=black,bg=red";
        };
        styles = {
          "alias" = "fg=magenta";
        };
        highlighters = ["main" "brackets" "pattern"];
      };
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        path = "echo -e \${PATH//:/\\\\n}";

        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";

        grep = "grep --color=auto";
        sgrep = "grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";

        logout = "loginctl terminate-session self";
        poweroff = "systemctl poweroff";
      };
      setOptions = [
        # Changing directories
        "AUTO_CD"
        "AUTO_PUSHD"
        "CDABLE_VARS"
        "CD_SILENT"
        "PUSHD_IGNORE_DUPS"
        "PUSHD_MINUS"

        # Completion
        "ALWAYS_TO_END"
        "AUTO_LIST"
        "AUTO_MENU"
        "AUTO_PARAM_SLASH"
        "COMPLETE_ALIASES"
        "COMPLETE_IN_WORD"
        "GLOB_COMPLETE"
        "HASH_LIST_ALL"
        "LIST_PACKED"
        "LIST_TYPES"

        # Expansion and Globbing
        "GLOB_DOTS"
        "EXTENDED_GLOB"

        # History
        "BANG_HIST"
        "EXTENDED_HISTORY"
        "HIST_EXPIRE_DUPS_FIRST"
        "HIST_FIND_NO_DUPS"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_DUPS"
        "HIST_IGNORE_SPACE"
        "HIST_REDUCE_BLANKS"
        "HIST_SAVE_NO_DUPS"
        "HIST_VERIFY"
        "INC_APPEND_HISTORY"
        "SHARE_HISTORY"

        # Input/Output
        "CORRECT_ALL"
        "INTERACTIVECOMMENTS"

        # Job Control
        "LONG_LIST_JOBS"

        # Scripting
        "MULTIOS"
      ];
    };

    environment.pathsToLink = ["/share/zsh"];

    programs.fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

  };
}
