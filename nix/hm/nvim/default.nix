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

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-lspconfig

      # init.lua
      catppuccin-nvim
      snacks-nvim
      dial-nvim

      # bars.lua
      dropbar-nvim
      heirline-nvim
      mini-icons

      # cmp.lua
      friendly-snippets
      blink-cmp

      # lsp.lua
      nvim-lint
      conform-nvim

      # mini.lua
      mini-move
      mini-surround
      mini-ai
      mini-bracketed

      # move.lua
      flash-nvim

      # ui.lua
      which-key-nvim
      nui-nvim
      mini-files
      gitsigns-nvim
      nvim-highlight-colors

      # ts.lua
      nvim-treesitter-textobjects
      nvim-treesitter-context
      vim-matchup
      treesj
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
      ))
    ];

    extraLuaConfig =
      with pkgs.vimPlugins; # lua
      ''
        vim.loader.enable()
        require("options")
        require("keybinds")

        require("lazy").setup("plugins", {
          defaults = { lazy = true },
          install = { colorscheme = { "catppuccin" }, missing = false },
          lockfile = nil,
          rocks = { enabled = false },
          dev = { path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start", patterns = { "" } },
          performance = {
            reset_packpath = false,
            rtp = {
              reset = false,
              disabled_plugins = {
                "tohtml",
                "gzip",
                "zipPlugin",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tutor",
              },
            },
          },
          change_detection = { notify = false },
        })
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
      nixfmt
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
