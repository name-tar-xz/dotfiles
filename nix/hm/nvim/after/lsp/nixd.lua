return {
  settings = {
    nixd = {
      nixpkgs = { expr = '(builtins.getFlake "/home/tarxz/.config/nixos").nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []' },
      options = { home_manager = { expr = '(builtins.getFlake "/home/tarxz/.config/nixos").nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []' } },
    },
  },
}
