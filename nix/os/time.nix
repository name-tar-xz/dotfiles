{ ... }:
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
    };
  };

  networking.timeServers = [
    "1.ntp.ubuntu.com"
    "2.ntp.ubuntu.com"
    "3.ntp.ubuntu.com"
    "4.ntp.ubuntu.com"
  ];
}
