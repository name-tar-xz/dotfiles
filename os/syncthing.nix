_: {
  services.syncthing = {
    enable = false;
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

      folders =
        let
          dev = [
            "F13"
            "laptop"
          ];
        in
        {
          ROMS = {
            path = "~/Games/ROMS";
            devices = dev;
            versioning.type = "simple";
          };
          Saves = {
            path = "~/.config/retroarch/saves";
            devices = dev;
            versioning.type = "simple";
          };
          States = {
            path = "~/.config/retroarch/states";
            devices = dev;
            versioning.type = "simple";
          };
          Previews = {
            path = "~/.config/retroarch/state-previews";
            devices = dev;
            versioning.type = "simple";
          };
        };
    };
  };
}
