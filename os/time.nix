{ pkgs, ... }:
{
  time = {
    timeZone = "Asia/Kolkata";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    timesyncd.enable = false;
    chrony = {
      enable = true;
      enableNTS = true;
      extraFlags = [ "-F1" ];
      extraConfig = ''
        minsources 3
        authselectmode prefer
        dscp 46
        leapseclist ${pkgs.tzdata}/share/zoneinfo/leap-seconds.list
        makestep 1.0 3
        cmdport 0
        noclientlog
      ''; # https://github.com/GrapheneOS/infrastructure/blob/main/etc/chrony.conf
    };
  };

  networking.timeServers = [
    "time.cloudflare.com"
    "ntppool1.time.nl"
    "nts.netnod.se"
    "ptbtime1.ptb.de"
    "time.dfm.dk"
    "time.cifelli.xyz"
  ];
}
