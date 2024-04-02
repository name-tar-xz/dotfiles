{
  description = "Nix Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur.url = "github:nix-community/NUR";
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
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

    hblock = {
      url = "file+https://hblock.molinero.dev/hosts";
      flake = false;
    };
    nero = {
      url = "gitlab:name.tar.xz/Nero";
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
      chaotic,
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
