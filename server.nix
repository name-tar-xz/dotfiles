{ config, ... }:
{
  networking.hostName = "server";

  services = {
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
  };
}
