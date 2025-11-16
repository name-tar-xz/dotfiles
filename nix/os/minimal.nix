{ lib, ... }:
{
  boot.enableContainers = false;
  appstream.enable = false;

  environment = {
    defaultPackages = [ ];
    stub-ld.enable = false;
  };

  documentation = {
    nixos.enable = false;
    info.enable = false;
    doc.enable = false;
    man.man-db.enable = false;
  };

  system.disableInstallerTools = true;

  services = {
    userborn.enable = true;
    speechd.enable = false;
  };

  programs.command-not-found.enable = false;

  xdg = {
    sounds.enable = false;
    autostart.enable = lib.mkForce false;
  };
}
