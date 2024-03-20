{ config, ... }:
{
  imports = [ ./common.nix ];

  networking.hostName = "server";

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.tailscale.path;
    };

    minecraft-server = {
      enable = true;
      eula = true; # set to true if you agree to Mojang's EULA: https://account.mojang.com/documents/minecraft_eula
      declarative = true;

      # See here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
      serverProperties = {
        server-port = 25565;
        online-mode = false;
        difficulty = "normal";
        gamemode = "survival";
        motd = "The Server";
        max-players = 6;
        max-threads = 0;
      };
    };
    terraria = {
      enable = true;
      maxPlayers = 8;
      autoCreatedWorldSize = "large";
    };

    resolved = {
      enable = true;
      extraConfig = ''
        DNS=45.90.28.0#Lenovo-***REMOVED***.dns.nextdns.io
        FallbackDNS=2a07:a8c0::#Lenovo-***REMOVED***.dns.nextdns.io
        DNS=45.90.30.0#Lenovo-***REMOVED***.dns.nextdns.io
        FallbackDNS=2a07:a8c1::#Lenovo-***REMOVED***.dns.nextdns.io
        DNSOverTLS=yes
        DNSSEC=yes
        MulticastDNS=yes
        Cache=yes
        ReadEtcHosts=yes
      '';
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/tarxz/.config/sops/age/keys.txt";

    secrets = {
      "wg" = { };
      "tailscale" = { };
    };
  };
}
