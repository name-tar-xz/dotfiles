{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_cachyos-server;

  networking = {
    hostName = "server";
    networkmanager.enable = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjfC5kank8ZpPF5Jqq/Z8vev0oryX2nnzcPK4IYj38O git.3myp3@slmail.me"
  ];

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    logind.lidSwitch = "ignore";

    nextcloud = {
      enable = true;
      configureRedis = true;
      package = pkgs.nextcloud29;
      hostName = "127.0.0.1";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) phonetrack;
      };
      settings =
        let
          prot = "https";
          host = "server.tailf29b7.ts.net";
          dir = "/nextcloud";
        in
        {
          overwriteprotocol = prot;
          overwritehost = host;
          overwritewebroot = dir;
          overwrite.cli.url = "${prot}://${host}${dir}/";
          htaccess.RewriteBase = dir;

          trusted_domains = [ "server.tailf29b7.ts.net" ];
        };
      config.adminpassFile = config.sops.secrets.nextcloudpass.path;
    };

    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = ":8080";
        base-url = "https://server.tailf29b7.ts.net";
      };
    };

    minecraft-server = {
      enable = false;
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
      enable = false;
      maxPlayers = 8;
      autoCreatedWorldSize = "large";
    };
  };

  systemd.services.tailscale-funnel = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "tailscaled.service"
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.tailscale}/bin/tailscale funnel --bg --set-path /nextcloud 80
      ${pkgs.tailscale}/bin/tailscale funnel --bg --set-path /ntfy 8080
    '';
  };

  sops.secrets = {
    nextcloudpass.mode = "0444";
  };

  system.stateVersion = "24.05";
}
