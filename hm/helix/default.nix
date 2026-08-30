{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."helix/init.scm".source = ./init.scm;

  catppuccin.helix = {
    enable = true;
    useItalics = true;
  };

  programs.helix = {
    enable = true;
    package = pkgs.steelix;
    settings = {
      editor = {
        line-number = "relative";
        scrolloff = 999;
        cursorline = true;
        color-modes = true;
        trim-trailing-whitespace = true;
        insert-final-newline = false;
        text-width = 120;

        statusline = {
          mode = {
            normal = "";
            insert = "";
            select = "";
          };

          left = [
            "mode"
            "spacer"
            "version-control"
            "file-type"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position"
            "file-encoding"
            "mode"
          ];
        };

        lsp.display-inlay-hints = true;

        cursor-shape = {
          insert = "bar";
          select = "underline";
        };

        auto-save.focus-lost = true;

        gutters = {
          layout = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];

          line-numbers.min-width = 1;
        };
      };
    };

    languages = {
      language-server.steel-language-server.command = ".steel-language-server-wrapped";

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
            roots = [ "flake.nix" ];
            args = [ "--width=120" ];
          };
        }
        {
          name = "python";
          auto-format = true;
          roots = [ "ruff.toml" ];
          language-servers = [
            "ruff"
            "basedpyright"
          ];
        }
      ];
    };

    inherit (config.programs.neovim) extraPackages;
  };
}
