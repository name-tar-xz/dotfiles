{
  description = "Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
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

    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      anyrun = {
        url = "github:Kirottu/anyrun";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */
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
      home-manager,
      lanzaboote,
      catppuccin,
      sops-nix,
      ...
    }@inputs:
    let
      system = nixpkgs.system;
    in
    # pkgs = nixpkgs.legacyPackages.${system};
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            home-manager.nixosModules.home-manager
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
            sops-nix.nixosModules.sops
            ./common.nix
            ./server-hardware.nix
            ./server.nix
          ];
        };
      };
    };
}
