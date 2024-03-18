{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.zsh;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh-fzf-tab
      fd
    ];

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";

      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        styles = {
          "alias" = "fg=magenta";
        };
        highlighters = ["main" "brackets" "pattern"];
      };

      cdpath = [];
      dirHashes = {
        nixos = "\$HOME/nixos";
        config = "\$XDG_CONFIG_HOME";
        locale = "\XDG_DATA_HOME";
        state = "\XDG_STATE_HOME";
        dl = "\$HOME/Downloads";
        gh = "\$HOME/dev/github";
        work = "\$HOME/dev/work";
      };

      history = {
        path = "$XDG_STATE_HOME/zsh/zsh_history";
      };

      envExtra = builtins.readFile ./env-extra.zsh;

      initExtraBeforeCompInit = builtins.readFile ./init-extra-before-comp-init.zsh;
      initExtra = builtins.readFile ./init-extra.zsh;

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";

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

        less = "less -R";

        ssh-add-keys = "eval '\$(ssh-agent -s)' && ssh-add";

        words = "rg --pretty --with-filename --hidden --follow -g '!.git'";
        files = "fd --type f --hidden --follow --exclude.git";

        startx = "startx \$XDG_CONFIG_HOME/X11/xinitrc";
        startw = "Hyprland";

        wget = "wget --hsts-file='\$XDG_DATA_HOME/wget-hsts'";
        du = "gdu";

        uuid-clip = "uuidgen | tr -d \\\\n | wl-copy";
      };

      shellGlobalAliases = {
        UUID = "\$(uuidgen | tr -d \\\\n)";
      };

      plugins = [
        # {
        #   name = "zsh-nix-shell";
        #   file = "nix-shell.plugin.zsh";
        #   src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        # }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "master";
            sha256 = "ilUavAIWmLiMh2PumtErMCpOcR71ZMlQkKhVOTDdHZw=";
          };
        }
      ];
    };

    programs.starship = {
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'head {}'"];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };
  };
}
