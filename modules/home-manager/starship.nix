{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.webflo.modules.starship;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.starship = {
    enable = mkEnableOption "starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;

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
          format = " [$symbol$pyenv_prefix($version)(($virtualenv))]($style)";
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
