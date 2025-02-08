{ config, pkgs, ... }:
{

  xdg.configFile = {
    "nixos/nix/hm/nvim/.runtime".source = "${config.programs.neovim.finalPackage}/share/nvim/runtime";

    "nvim/lua".source = ./lua;
    "nvim/after".source = ./after;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    extraLuaConfig =
      with pkgs.vimPlugins; # lua
      ''
        P = {
          -- init.lua
          catppuccin = "${catppuccin-nvim}",
          snacks = "${snacks-nvim}",
          dial = "${dial-nvim}",

          -- bars.lua
          dropbar = "${dropbar-nvim}",
          heirline = "${heirline-nvim}",
          mini_icons = "${mini-icons}",

          -- cmp.lua
          friendly_snippets = "${friendly-snippets}",
          blink = "${blink-cmp}",

          -- lsp.lua
          lspconfig = "${nvim-lspconfig}",
          lint = "${nvim-lint}",
          conform = "${conform-nvim}",
          trouble = "${trouble-nvim}",

          -- mini.lua
          mini_move = "${mini-move}",
          mini_surround = "${mini-surround}",
          mini_ai = "${mini-ai}",
          mini_bracketed = "${mini-bracketed}",

          -- move.lua
          flash = "${flash-nvim}",
          spider = "${nvim-spider}",

          -- ts.lua
          treesitter = "${nvim-treesitter}",
            treesitter_textobjects = "${nvim-treesitter-textobjects}",
            treesitter_context = "${nvim-treesitter-context}",
            ts_context_commentstring = "${nvim-ts-context-commentstring}",
            matchup = "${vim-matchup}",
          treesj = "${treesj}",

          -- ui.lua
          which_key = "${which-key-nvim}",

          noice = "${noice-nvim}",
            nui = "${nui-nvim}",
          mini_files = "${mini-files}",

          gitsigns = "${gitsigns-nvim}",
          colorizer = "${nvim-colorizer-lua}",
        }
        require("startup")
        vim.opt.rtp:append("${
          pkgs.symlinkJoin {
            name = "treesitter";
            paths =
              (nvim-treesitter.withPlugins (
                p: with p; [
                  # c, lua, markdown, query, vim, vimdoc installed by default
                  arduino
                  bash
                  css
                  git_config
                  git_rebase
                  gitattributes
                  gitcommit
                  gitignore
                  go
                  html
                  java
                  javascript
                  jsdoc
                  json
                  json5
                  jsonc
                  luap
                  markdown
                  markdown_inline
                  nix
                  norg
                  python
                  regex
                  rust
                  svelte
                  toml
                  typescript
                  udev
                  vim
                  vimdoc
                  vue
                  yaml
                  xml
                ]
              )).dependencies;
          }
        }")
      '';

    extraPackages = with pkgs; [
      # Formatter, LSP, Linters
      typos-lsp
      vscode-langservers-extracted
      ## TOML
      taplo
      ## Arduino
      arduino-language-server
      astyle
      ## Nix
      nixd
      nixfmt-rfc-style
      ## Shell
      shfmt
      shellcheck
      ## Lua
      lua-language-server
      stylua
      ## JavaScript
      biome
      vtsls
      ## Tailwind
      tailwindcss-language-server
      rustywind
      ## Go
      gopls
      gofumpt
      ## Python
      ruff
      basedpyright
    ];
  };
}
