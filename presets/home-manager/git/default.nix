{ config, ... }:
{
  age.secrets."git-config-github".file = ../../../secrets/git-config-github.age;

  # environment.etc."vanta.conf".source = config.age.secrets."vanta-conf".path;


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
      merge.ff = "only";

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
      merge = {
        conflicstyle = "diff3";
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

      safe = {
        directory = "/etc/nixos";
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

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:**/**";
        path = config.age.secrets."git-config-github".path;
      }
      # {
      #   path = "${config.home.homeDirectory}/git/config-github.inc";
      #   condition = "hasconfig:remote.*.url:git@github.com:**/**";
      # }
    ];
  };

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

}
