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

  xdg = {
    sounds.enable = false;
    autostart.enable = lib.mkForce false;
  };
}
