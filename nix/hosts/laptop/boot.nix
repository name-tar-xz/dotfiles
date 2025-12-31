{ lib, config, ... }:
{
  boot = {
    initrd = {
      systemd.enable = true;
      includeDefaultModules = false;

      clevis = {
        enable = true;
        devices."${config.fileSystems."/".device}".secretFile = ./secret.jwe;
      };
      availableKernelModules = [
        "tpm_crb"
        "tpm_tis"
      ];
    };

    supportedFilesystems = [ "bcachefs" ];

    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };

  console.earlySetup = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = "font-size=16";
    extraOptions = "--term xterm-256color";
  };
}
