{
  description = "Nix Flake";

  nixConfig = {
    extra-substituters = [ "https://nyx.chaotic.cx/" ];
    extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-schemas.follows = "";
        jovian.follows = "";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "https://flakehub.com/f/nix-community/lanzaboote/*.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit-hooks-nix.follows = "";
      };
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
        home-manager.follows = "";
        home-manager-stable.follows = "";
        nuscht-search.follows = "";
        catppuccin-v1_1.follows = "";
        catppuccin-v1_2.follows = "";
      };
    };
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      ags = {
        url = "github:Aylur/ags";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */
    /*
      aagl = {
        url = "github:ezKEa/aagl-gtk-on-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */

    nero = {
      url = "gitlab:tarzst/Nero";
      flake = false;
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
    {
      self,
      nixpkgs,
      chaotic,
      home-manager,
      lanzaboote,
      catppuccin,
      sops-nix,
      ...
    }@inputs:
    let
      system = nixpkgs.system;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            catppuccin.nixosModules.catppuccin
            sops-nix.nixosModules.sops
            ./common.nix
            ./laptop-hardware.nix
            ./laptop.nix
            /*
              imports = [ aagl.nixosModules.default ];
              programs.honkers-railway-launcher.enable = false;
            */
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops
            ./common.nix
            ./server-hardware.nix
            ./server.nix
          ];
        };
      };
    };
}
