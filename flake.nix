{
  description = "Nix Flake";

  nixConfig = {
    extra-substituters = [
      "https://lanzaboote.cachix.org"
      "https://nix-community.cachix.org"
      "https://catppuccin.cachix.org"
      "https://cache.xinux.uz"
    ];
    extra-trusted-public-keys = [
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst"; # Smaller tarball than pulling from github
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-parts.inputs.nixpkgs-lib.follows = "nix-cachyos-kernel/nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "https://flakehub.com/f/nix-community/lanzaboote/*.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aa-alias-manager = {
      url = "github:LordGrimmauld/aa-alias-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-github-actions.follows = "";
        pre-commit-hooks.follows = "";
      };
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      ags = {
        url = "github:Aylur/ags";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      aagl = {
        url = "github:ezKEa/aagl-gtk-on-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */

    phoenix = {
      url = "git+https://gitlab.com/celenityy/Phoenix?ref=pages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      formatter.x86_64-linux =
        with nixpkgs.legacyPackages.x86_64-linux;
        treefmt.withConfig {
          runtimeInputs = [
            nixfmt
            deadnix
            stylua
            yamlfmt
          ];

          settings.formatter = {
            nixfmt = {
              command = "nixfmt";
              options = [ "--width=120" ];
              includes = [ "*.nix" ];
            };
            deadnix = {
              command = "deadnix";
              options = [ "--edit" ];
              includes = [ "*.nix" ];
            };

            lua = {
              command = "stylua";
              includes = [ "*.lua" ];
            };
            yamlfmt = {
              command = "yamlfmt";
              includes = [
                "*.yaml"
                "*.yml"
              ];
            };
          };
        };

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            hostname = "laptop";
          };
          modules = [ ./os ];
        };

        server = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            hostname = "server";
          };
          modules = [ ./os ];
        };

        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            (
              { pkgs, ... }:
              {
                environment.systemPackages = [ pkgs.keyutils ];
                boot.supportedFilesystems = [ "bcachefs" ];
              }
            )
          ];
        };
      };
    };
}
