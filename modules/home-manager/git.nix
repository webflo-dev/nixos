{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.git;
  inherit (lib) mkEnableOption mkIf mkOption types mkDefault;

  includeModule = types.submodule ({config, ...}: {
    options = {
      condition = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Include this configuration only when {var}`condition`
          matches. Allowed conditions are described in
          {manpage}`git-config(1)`.
        '';
      };

      path = mkOption {
        type = types.either types.str types.path;
        description = "Path of the configuration file to include.";
      };

      contents = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        # example = literalExpression ''
        #   {
        #     user = {
        #       email = "bob@work.example.com";
        #       name = "Bob Work";
        #       signingKey = "1A2B3C4D5E6F7G8H";
        #     };
        #     commit = {
        #       gpgSign = true;
        #     };
        #   };
        # '';
        # description = ''
        #   Configuration to include. If empty then a path must be given.

        #   This follows the configuration structure as described in
        #   {manpage}`git-config(1)`.
        # '';
      };

      contentSuffix = mkOption {
        type = types.str;
        default = "gitconfig";
        # description = ''
        #   Nix store name for the git configuration text file,
        #   when generating the configuration text from nix options.
        # '';
      };
    };
  });
in {
  options.webflo.modules.git = {
    enable = mkEnableOption "git";

    includes = mkOption {
      type = types.listOf includeModule;
      default = [];
      # example = literalExpression ''
      #   [
      #     { path = "~/path/to/config.inc"; }
      #     {
      #       path = "~/path/to/conditional.inc";
      #       condition = "gitdir:~/src/dir";
      #     }
      #   ]
      # '';
    };
  };

  config = mkIf cfg.enable {
    # age = {
    #   identityPaths = [
    #     "${config.home.homeDirectory}/.ssh/agenix-git-config-github"
    #   ];
    #   secrets = {
    #     git-config-github.file = ../../../secrets/git-config-github.age;
    #   };
    # };

    programs.git = {
      enable = true;
      lfs.enable = true;

      extraConfig = {
        core = {
          untrackedCache = true;
        };

        color = {
          ui = "auto";
          branch = {
            current = "yellow reverse";
            local = "yellow";
            remote = "green";
          };
          diff = {
            meta = "yellow bold";
            frag = "magenta bold"; # line info
            old = "red"; # deletions
            new = "green"; # additions
          };
          status = {
            added = "yellow";
            changed = "green";
            untracked = "cyan";
          };
        };

        pull.ff = "only";
        merge = {
          conflicstyle = "diff3";
          ff = "only";
        };

        diff = {
          renames = "copies";
          tool = "nvimdiff";
        };
        difftool = {
          prompt = true;
          nvimdiff = {
            cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
          };
        };

        help = {
          autocorrect = 1;
        };

        credential = {
          helper = "cache --timeout=604800";
        };

        init = {
          defaultBranch = "main";
        };
      };

      aliases = {
        tags = "tag - l";
        branches = "branch -a";
        remotes = "remote -v";
        aliases = "config --get-regexp alias";

        s = "status -s";
        l = "!git log --pretty=format:'%C(green)%ad %C(yellow)%h%C(auto)%d %C(reset)%s  %C(cyan)<%C(blue)%cn%C(cyan)>%Creset' --date=short";

        trash = "!git reset --hard HEAD && git clean -fd";
        stash-save = "!f() { git stash save -u $1; }; f";
        amend = "commit --amend --reuse-message=HEAD";
        unstage = "restore --staged";

        wip = "!f() { git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m '[wip] [skip ci]'; }; f";
        unwip = "!f() { git log -n 1 | grep -q -c '[wip]' && git reset HEAD~1; }; f";

        # Interactive rebase with the given number of latest commits
        rbi = "!r() { git rebase -i HEAD~$1; }; r";

        # Show the diff between the latest commit and the current state
        d = "!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";

        # `git di $number` shows the diff between the state `$number` revisions ago and the current state
        di = "!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d";

        # Find branches containing commit
        find-branch = "!f() { git branch -a --contains $1; }; f";

        # Find tags containing commit
        find-tag = "!f() { git describe --always --contains $1; }; f";

        # Find commits by source code
        find-commit-by-code = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";

        # Find commits by commit message
        find-commit-by-message = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";

        # Remove branches that have already been merged with master
        # a.k.a. ‘delete merged’
        delete-branch-merged = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";

        # Remove local branches which do not exist on remote server
        delete-branch-local = "!git branch -vv | grep ': gone]' | awk '{ print $1 }' | xargs -r -n 1 git branch -D";

        # Sort local branches by date
        local-branche-by-date = "!git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";

        # Remove local branches which do not exist on remote server
        prune-branches = "!git remote prune origin && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D";
      };

      includes = cfg.includes;
      # includes = [
      #   {
      #     condition = "hasconfig:remote.*.url:git@github.com:**/**";
      #     inherit (config.age.secrets."git-config-github") path;
      #   }
      # ];
    };

    home.packages = with pkgs; [
      gitui
      lazygit
    ];

    programs.git.delta = {
      enable = true;

      options = {
        features = "decorations";
        whitespace-error-style = "22 reverse";
        line-numbers = "true";
        side-by-side = "true";
        blame-code-style = "syntax";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
        };
      };
    };
  };
}
