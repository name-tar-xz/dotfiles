_: {
  programs.firefox.policies."3rdparty".Extensions."uBlock0@raymondhill.net" = {
    toOverwrite = {
      filters = [ "*$font,third-party" ];
      filterLists = [
        "user-filters"
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

    adminSettings.dynamicFilteringString = ''
      * * 3p-frame block
      * * 3p-script block
      * challenges.cloudflare.com * noop
      * hcaptcha.com * noop
      * discourse-cdn.com * noop

      behind-the-scene * * noop
      behind-the-scene * 1p-script noop
      behind-the-scene * 3p noop
      behind-the-scene * 3p-frame noop
      behind-the-scene * 3p-script noop
      behind-the-scene * image noop
      behind-the-scene * inline-script noop

      github.com githubassets.com * noop
    ''; # https://github.com/uBlockOrigin/uBlock-issues/issues/3534

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
}
