{
  pkgs,
  config,
  hostname,
  ...
}:
{
  boot = {
    kernel.sysctl = {
      "net.core.rmem_max" = 8388608;
      "net.core.wmem_max" = 8388608;
    };
    extraModprobeConfig = "options cfg80211 ieee80211_regdom=IN";
  };

  services = {
    resolved.enable = false;

    routedns = {
      enable = true;
      configFile = "/etc/routedns.toml";
      settings = {
        resolvers.nextdns = {
          address = "${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io:853";
          bootstrap-address = "45.90.28.166";
          protocol = "doq";
          enable-0rtt = true;
        };

        groups = {
          cached = {
            type = "cache";
            resolvers = [ "dedup" ];
          };

          dedup = {
            type = "request-dedup";
            resolvers = [ "minimize" ];
          };

          minimize = {
            type = "response-minimize";
            resolvers = [ "collapse" ];
          };

          collapse = {
            type = "response-collapse";
            resolvers = [ "nextdns" ];
          };
        };

        listeners = {
          local-udp = {
            address = "127.0.0.1:53";
            protocol = "udp";
            resolver = "cached";
          };
          local-tcp = {
            address = "127.0.0.1:53";
            protocol = "tcp";
            resolver = "cached";
          };
        };
      };
    };
  };

  systemd.network = {
    wait-online.enable = false;
    links."30-wlan" = {
      matchConfig.Type = "wlan";
      linkConfig = {
        MTUBytes = 1492;
        TransmitQueueLength = 2000;
        MACAddressPolicy = "random";
      };
    };
  };

  networking = {
    hostName = hostname;
    useNetworkd = true;
    wireless = {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      userControlled.enable = true;
      extraConfig = ''
        country=IN
        p2p_disabled=1
        mac_addr=1
      '';
    };

    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
      # extraCommands = "iptables -A INPUT -p icmp -j ACCEPT";
    };

    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.2.0.2/32" ];
        privateKeyFile = config.sops.secrets.wg.path;
        peers = [
          {
            allowedIPs = [ "0.0.0.0/0" ];
            publicKey = "jDrSMRMm6XJgYGcSd01QqJbYiW13dyaOKp8GWDs0rTQ=";
            endpoint = "185.177.125.173:51820";
          }
        ];
      };
    };
  };

  sops = {
    templates.routedns = {
      file = (pkgs.formats.toml { }).generate "routedns.toml" config.services.routedns.settings;
      path = "/etc/routedns.toml";
      mode = "0444";
    };
    secrets.nextdns.mode = "0444";
  };
}
