_: {
  services.pipewire =
    let
      quantum = 64;
      rate = 48000;
      qr = "${quantum}/${rate}";
    in
    {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      extraConfig = {
        pipewire."99-lowlatency" = {
          "context.properties" = {
            "default.clock.rate" = rate;
            "default.clock.allowed-rates" = [
              44100
              (44100 * 2)
              rate
              (rate * 2)
            ];
            "default.clock.quantum" = quantum;
            "default.clock.quantum-limit" = quantum;
            "default.clock.max-quantum" = quantum;
            "default.clock.min-quantum" = quantum / 2;
          };

          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              flags = [
                "ifexists"
                "nofail"
              ];
              args = {
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
          ];
        };

        pipewire-pulse."99-lowlatency"."pulse.properties" = {
          "server.address" = [ "unix:native" ];
          "pulse.default.req" = qr;
          "pulse.min.req" = qr;
          "pulse.min.quantum" = qr;
          "pulse.min.frag" = qr;
        };

        client."99-lowlatency"."stream.properties" = {
          "node.latency" = qr;
          "resample.quality" = 1;
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "51-bluetooth" = {
            "monitor.bluez.properties" = {
              "bluez5.default.rate" = rate; # 48000 or 44100
              "bluez5.default.channels" = 2;
            };
            "monitor.bluez.rules" = [
              {
                matches = [ { "device.name" = "~bluez_card.*"; } ];
                actions.update-props = {
                  "bluez5.a2dp.ldac.quality" = "auto";
                  "bluez5.a2dp.aac.bitratemode" = 5;
                };
              }
            ];
          };

          "99-alsa-lowlatency"."monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "~alsa_output.*"; } ];
              actions.update-props = {
                "api.alsa.period-num" = 3;
                "api.alsa.period-size" = quantum;
                "audio.rate" = rate;
              };
            }
          ];
        };
      };
    };
}
