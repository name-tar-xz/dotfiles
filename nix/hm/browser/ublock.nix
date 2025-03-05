{ ... }:
{
  home.file.".mozilla/managed-storage/uBlock0@raymondhill.net.json".text = builtins.toJSON {
    data = {
      toOverwrite = {
        filterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "easyprivacy"
          "adguard-spyware"
          "adguard-spyware-url"
          "block-lan"
          "urlhaus-1"
          "curben-phishing"
          "plowe-0"
          "adguard-cookies"
          "ublock-cookies-adguard"
          "fanboy-social"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "ublock-annoyances"
          "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
          "https://github.com/DandelionSprout/adfilt/raw/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
          "https://github.com/yokoffing/filterlists/raw/main/annoyance_list.txt"
          "https://github.com/yokoffing/filterlists/raw/refs/heads/main/privacy_essentials.txt"
          "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/block_third_party_fonts.txt"
          "https://github.com/DandelionSprout/adfilt/raw/refs/heads/master/LegitimateURLShortener.txt"
        ];
      };
      userSettings = [
        [
          "advancedUserEnabled"
          "true"
        ]
        [
          "prefetchingDisabled"
          "false"
        ]
        [
          "popupPanelSections"
          "31"
        ]
      ];
    };
    description = "_";
    name = "uBlock0@raymondhill.net";
    type = "storage";
  };
}
