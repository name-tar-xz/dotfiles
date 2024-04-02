{ config, pkgs, ... }:
{
  networking.hostName = "server";

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    logind.lidSwitch = "ignore";

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      hostName = "localhost";
      autoUpdateApps.enable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) phonetrack;
      };
      settings = {
        trusted_domains = [
          "server.tailf29b7.ts.net"
          "100.118.136.122"
        ];
      };
      config.adminpassFile = config.sops.secrets.nextcloudpass.path;
    };

    tailscale.authKeyFile = config.sops.secrets.tailscale-server.path;
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
  };

  sops.secrets = {
    tailscale-server = { };
    nextcloudpass.mode = "0444";
  };
}
