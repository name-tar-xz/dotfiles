_: {
  services.pipewire =
    let
      quantum = 64;
      rate = 48000;
      qr = "${toString quantum}/${toString rate}";
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
        extraConfig."99-alsa-lowlatency"."monitor.alsa.rules" = [
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
}
