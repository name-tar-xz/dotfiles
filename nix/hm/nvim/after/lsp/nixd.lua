return {
  settings = {
    nixd = {
      nixpkgs = { expr = "import <nixpkgs> { }" },
      options = {
        nixos = { expr = '(builtins.getFlake ("git+file://" + builtins.toString ./.)).nixosConfigurations.laptop.options' },
        home_manager = { expr = '(builtins.getFlake ("git+file://" + builtins.toString ./.)).nixosConfigurations.laptop.options.home-manager.users.type.getSubOptions []' },
      },
    },
  },
}
