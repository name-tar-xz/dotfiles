{ lib, ... }:
{
  boot.enableContainers = false;

  environment = {
    defaultPackages = [ ];
    stub-ld.enable = false;
  };

  documentation = {
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
  };

  system.disableInstallerTools = true;

  programs.command-not-found.enable = false;

  xdg = {
    sounds.enable = false;
    autostart.enable = lib.mkForce false;
  };
}
