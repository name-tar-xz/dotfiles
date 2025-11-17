_:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    relay.enable = false;
    settings = {
      gui.theme = "black";

      options = {
        relaysEnabled = true;
        urAccepted = -1;
      };

      devices = {
        F13.id = "PZ5ZLDN-JGGKAXL-2YRWHGA-Q5KZT6U-2IMCA2E-V5GCFWX-76PXM5B-3HTEBQD";
        laptop.id = "Z2NATQ7-GOXCMGJ-EJD6VEJ-GLDAZRD-VJU2RMX-AVGB72V-AJZOFUI-WVJUXAM";
      };

      folders = {
        ROMS = {
          path = "~/Games/ROMS";
          devices = [
            "F13"
            "laptop"
          ];
          versioning.type = "simple";
        };
        Saves = {
          path = "~/.config/retroarch/saves";
          devices = [
            "F13"
            "laptop"
          ];
          versioning.type = "simple";
        };
        States = {
          path = "~/.config/retroarch/states";
          devices = [
            "F13"
            "laptop"
          ];
          versioning.type = "simple";
        };
        Previews = {
          path = "~/.config/retroarch/state-previews";
          devices = [
            "F13"
            "laptop"
          ];
          versioning.type = "simple";
        };
      };
    };
  };
}
