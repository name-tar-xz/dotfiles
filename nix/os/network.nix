{
  pkgs,
  config,
  hostname,
  ...
}:
{
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=IN";

  services = {
    resolved.enable = false;

    routedns = {
      enable = true;
      configFile = "/etc/routedns.toml";
      settings = {
        resolvers.adguard = {
          address = "${config.sops.placeholder.adguard}.d.adguard-dns.com:853";
          bootstrap-address = "94.140.14.49";
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
            resolvers = [ "adguard" ];
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

    udev.extraRules = /* udev */ ''ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", ATTR{mtu}="1492", ATTR{tx_queue_len}="2000"'';
  };

  systemd.network.wait-online.enable = false;

  networking = {
    hostName = hostname;

    useNetworkd = true;
    resolvconf.enable = false;

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          AddressRandomization = "network";
          DisableANQP = false;
          Country = "IN";
        };
        Network.NameResolvingService = "none";
        Scan.DisablePeriodicScan = true;
      };
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
    secrets.adguard.mode = "0444";
  };
}
