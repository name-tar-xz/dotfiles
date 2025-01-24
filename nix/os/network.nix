{ config, ... }:
{
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
  };

  systemd.network = {
    wait-online.enable = false;
    links."30-mtu" = {
      matchConfig.Type = "wlan";
      linkConfig = {
        MTUBytes = 1492;
        TransmitQueueLength = 2000;
      };
    };
  };

  networking = {
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
    templates.resolved = {
      content = ''
        [Resolve]
        DNS=45.90.28.0#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        FallbackDNS=2a07:a8c0::#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        DNS=45.90.30.0#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
        FallbackDNS=2a07:a8c1::#${config.networking.hostName}-${config.sops.placeholder.nextdns}.dns.nextdns.io
      '';
      path = "/etc/systemd/resolved.conf.d/dns.conf";
      mode = "0444";

    };
    secrets.nextdns.mode = "0444";
  };
}
