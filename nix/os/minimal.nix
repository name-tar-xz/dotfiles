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

  system = {
    disableInstallerTools = true;
    nixos-init.enable = true;
    etc.overlay = {
      enable = true;
      mutable = true;
    };
  };

  services = {
    userborn.enable = true;
    speechd.enable = false;
  };

  programs = {
    command-not-found.enable = false;
    bash.enable = false;
  };

  xdg = {
    sounds.enable = false;
    autostart.enable = lib.mkForce false;
  };
}
