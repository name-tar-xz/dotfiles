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
        jovian.follows = "";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
      };
    };
    lanzaboote = {
      url = "https://flakehub.com/f/nix-community/lanzaboote/*.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        pre-commit-hooks-nix.follows = "";
      };
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
      sops-nix,
      lanzaboote,
      chaotic,
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
            lanzaboote.nixosModules.lanzaboote
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
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
