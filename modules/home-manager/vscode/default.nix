{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.webflo.modules.vscode;
  inherit (lib) mkEnableOption mkIf;
in {
  options.webflo.modules.vscode = {
    enable = mkEnableOption "VS Code";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions;
        [
          enkia.tokyo-night
          jnoortheen.nix-ide
          mikestead.dotenv
          editorconfig.editorconfig
          usernamehw.errorlens
          dbaeumer.vscode-eslint
          github.copilot
          github.copilot-chat
          eamodio.gitlens
          kamikillerto.vscode-colorize
          apollographql.vscode-apollo
          golang.go
          sumneko.lua
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax
          ibm.output-colorizer
          christian-kohler.path-intellisense
          esbenp.prettier-vscode
          mechatroner.rainbow-csv
          # ms-vscode-remote.remote-ssh
          vscode-icons-team.vscode-icons
          # vscodevim.vim
          # asvetliakov.vscode-neovim

          ### Disabled extensions. To use maybe later.
          # codeium.codeium
          # gitlab.gitlab-workflow
          # idered.npm
          # antfu.slidev
          # sudoaugustin.vslook
        ]
        ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          kdl-org.kdl
          meganrogge.template-string-converter
          visualstudioexptteam.vscodeintellicode
          christian-kohler.npm-intellisense
          ionutvmi.path-autocomplete
          # mylesmurphy.prettify-ts
          meganrogge.template-string-converter
          # ms-vscode-remote.remote-ssh-edit
          # ms-vscode.remote-explorer
          # ms-vscode.remote-repositories
          tonybaloney.vscode-pets
          alexcvzz.vscode-sqlite
          # deque-systems.vscode-axe-linter
          # webhint.vscode-webhint
          adpyke.vscode-sql-formatter
          team-sapling.sapling
        ]);

      userSettings = {
        # "files.autoSave" = "off";
        # "[nix]"."editor.tabSize" = 2;

        ### IDE settings
        "window.titleBarStyle" = "custom";
        "editor.acceptSuggestionOnCommitCharacter" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
        };
        "editor.cursorBlinking" = "phase";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.fontFamily" = "monospace, 'Symbols Nerd Font', 'Font Awesome 6 Pro'";
        "editor.fontLigatures" = true;
        "editor.fontVariations" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "file";

        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "editor.guides.bracketPairs" = true;
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "editor.inlineSuggest.enabled" = true;
        "editor.lineNumbers" = "relative";
        "editor.linkedEditing" = true;
        "editor.occurrencesHighlight" = "multiFile";
        "editor.parameterHints.cycle" = true;
        "editor.parameterHints.enabled" = true;
        "editor.quickSuggestions" = {
          "comments" = false;
          "other" = true;
          "strings" = true;
        };
        "editor.renderWhitespace" = "trailing";
        "editor.showFoldingControls" = "always";
        "editor.snippetSuggestions" = "none";
        "editor.stickyScroll.enabled" = true;
        "editor.suggest.insertMode" = "replace";
        "editor.suggest.localityBonus" = true;
        "editor.suggest.matchOnWordStartOnly" = false;
        "editor.suggest.preview" = true;
        "editor.suggestOnTriggerCharacters" = true;
        "editor.suggestSelection" = "recentlyUsedByPrefix";
        "editor.tabSize" = 2;
        "editor.unicodeHighlight.nonBasicASCII" = false;
        "editor.wordBasedSuggestions" = "currentDocument";

        "explorer.autoRevealExclude" = {
          "**/node_modules" = true;
        };

        "files.associations" = {
          "*.rules" = "yaml";
          ".commitlintrc" = "json";
          ".eslintrc" = "json";
          ".huskyrc" = "json";
          ".lintstagedrc" = "json";
          ".prettierrc" = "json";
          ".releaserc" = "json";
        };
        "files.exclude" = {
          "**/.git" = true;
          "node_modules" = true;
        };
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/**" = true;
        };

        "terminal.explorerKind" = "external";
        "terminal.integrated.env.linux" = {};
        "terminal.integrated.fontWeightBold" = "normal";
        "terminal.integrated.gpuAcceleration" = "on";
        "terminal.integrated.localEchoLatencyThreshold" = -1;
        "terminal.integrated.smoothScrolling" = true;
        "terminal.integrated.tabs.enabled" = false;

        "screencastMode.fontSize" = 57;

        "search.exclude" = {
          "**/node_modules" = true;
        };

        "workbench.colorTheme" = "Tokyo Night";
        "workbench.editor.decorations.badges" = true;
        "workbench.editor.decorations.colors" = true;
        "workbench.editor.splitInGroupLayout" = "vertical";
        "workbench.list.smoothScrolling" = true;
        "workbench.tree.indent" = 15;
        "workbench.tree.renderIndentGuides" = "always";

        ### Extensions settings
        "errorLens.delay" = 500;
        "errorLens.delayMode" = "debounce";

        "redhat.telemetry.enabled" = false;

        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "alejandra";
        "nix.serverPath" = "nixd";
        # "nix.serverPath"= "nil";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = ["alejandra"];
            };
          };
          "nixd" = {
            "formatting" = {
              "command" = "alejandra";
            };
          };
        };
        "typescript.updateImportsOnFileMove.enabled" = "always";
      };
    };

    # programs.zsh = {
    #   shellAliases = {
    #     "code" = "codium";
    #   };
    # };
  };
}
