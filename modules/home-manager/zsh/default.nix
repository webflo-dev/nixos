{ config, lib, pkgs, ... }:
let
  cfg = config.webflo.modules.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.webflo.modules.zsh = {
    enable = mkEnableOption "zsh module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh-fzf-tab
    ];

    programs.zsh =
      {
        enable = true;
        dotDir = ".config/zsh";

        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        autocd = true;
        cdpath = [ ];
        defaultKeymap = "emacs";
        dirHashes = {
          # dl = "$HOME/Downloads";
        };

        history = {
          path = "${config.xdg.dataHome}/zsh/zsh_history";
          ignorePatterns = [
            "cd"
            "ranger"
            "kill"
          ];
          save = 10000;
          share = true;
          size = 10000;
        };

        envExtra = builtins.readFile ./env-extra.zsh;

        initExtraFirst = builtins.readFile ./init-extra-first.zsh;

        initExtra = builtins.readFile ./init-extra.zsh;

        shellAliases = {
          # ".." = "cd ..";
          # "..." = "cd ../..";
          # "...." = "cd ../../..";

          # grep = "grep --color=auto";
          # sgrep = "grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}";
          # fgrep = "fgrep --color=auto";
          # egrep = "egrep --color=auto";
          less = "less -R";

          # rm = "rm -i";
          # cp = "cp -i";
          # mv = "mv -i";
          # mkdir = "mkdir -p";


          view = "bat";
          cat = "bat -p";
          more = "bat -p";

          # ls='ls -l -h -v --group-directories-first --time-style=+"%Y-%m-%d %H:%M" --color=auto -F --tabsize=0 --literal --show-control-chars --color=always --human-readable'
          # la='ls -a'
          ls = "eza -la -L 3 --git --group-directories-first --ignore-glob='node_modules|.git' --icons";
          la = "ls";
          l = "ls";

          # path = "echo -e \${PATH//:/\\n}";

          ssh-add-keys = "eval '$(ssh-agent -s)' && ssh-add";

          # logout = "loginctl terminate-session self";
          # poweroff = "systemctl poweroff";

          words = "rg --pretty --with-filename --hidden --follow -g '!.git'";
          files = "fd --type f --hidden --follow --exclude.git";

          startx = "startx $XDG_CONFIG_HOME/X11/xinitrc";
          startw = "Hyprland";

          wget = "wget --hsts-file='$XDG_DATA_HOME/wget-hsts'";
          du = "gdu";

          uuid-clip = "uuidgen | tr -d \\\\n | wl-copy";
        };

        shellGlobalAliases = {
          UUID = "$(uuidgen | tr -d \\\\n)";
        };

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
          }
        ];
      };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        directory = {
          read_only = " 󰌾 ";
          truncation_symbol = ".../";
          truncation_length = 5;
          format = "[$path]($style)[$read_only]($read_only_style)";
          repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        };

        aws = {
          disabled = true;
          format = " [$symbol($profile)(\($region\))(\[$duration\])]($style)";
          symbol = "󰸏 ";
        };

        bun = {
          format = " [$symbol($version)]($style)";
        };

        cmd_duration = {
          format = " [󱎫 $duration]($style)";
          style = "yellow";
        };

        deno = {
          format = " [$symbol($version)]($style)";
        };

        docker_context = {
          symbol = "󰡨 ";
          format = " [$symbol]($style)";
        };

        gcloud = {
          disabled = true;
          format = " [$symbol$account(@$domain)(\($region\))]($style)";
        };

        git_branch = {
          symbol = " ";
          format = " [$symbol$branch]($style)";
        };

        git_status = {
          format = " [$all_status$ahead_behind]($style)";
          ahead = "↑";
          behind = "↓";
          diverged = "↕";
          up_to_date = "";
          untracked = "?";
          stashed = "≡";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "x";
        };

        golang = {
          # symbo = " "
          symbol = " ";
          format = " [$symbol($version)]($style)";
        };

        lua = {
          symbol = " ";
          format = " [$symbol($version)]($style)";
        };

        nix_shell = {
          symbol = " ";
          format = " [$symbol$state( \($name\))]($style)";
        };

        nodejs = {
          symbol = "󰎙 ";
          format = " [$symbol($version)]($style)";
        };

        package = {
          symbol = "󰏗 ";
          format = " [$symbol$version]($style)";
        };

        python = {
          symbol = " ";
          format = " [$symbol$pyenv_prefix($version)(\($virtualenv\))]($style)";
        };

        rust = {
          symbol = " ";
          format = " [$symbol($version)]($style)";
        };

        sudo = {
          format = " [as $symbol]";
        };


        time = {
          format = " [$time]($style)";
        };

        username = {
          format = " [$user]($style)";
        };
      };
    };
  };
}

