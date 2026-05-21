_: {
  programs.firefox.policies."3rdparty".Extensions."uBlock0@raymondhill.net" = {
    toOverwrite = {
      filters = [
        "search.brave.com##+js(set-cookie, useLocation, 0)" # Disable "Anonymous local results"
        "search.brave.com##+js(set-cookie, summarizer, 0)" # Disable "Answer with AI"
        "search.brave.com##+js(set-cookie, safesearch, off)" # Disable Safe Search
        "search.brave.com##+js(set-cookie, olnt, 1)" # Open links in new tab
        "search.brave.com##+js(set-cookie, country, all)" # Search in all regions
        "search.brave.com##+js(trusted-set-cookie, theme, dark, , , reload, 1)"

        # Dark Mode Rules
        "wikipedia.org##+js(trusted-set-cookie, enwikimwclientpreferences, skin-theme-clientpref-night)"
        "duckduckgo.com##+js(trusted-set-cookie, ae, d)"
        "espncricinfo.com##+js(trusted-set-local-storage-item, ci-theme-preference, DARK)"
        "wiki.archlinux.org##+js(trusted-set-cookie, archwikimwclientpreferences, skin-theme-clientpref-night, , , reload, 1)"
        "wiki.cachyos.org##+js(trusted-set-local-storage-item, starlight-theme, dark)"
        "wiki.hypr.land##+js(trusted-set-local-storage-item, color-theme, dark)"

        # Redlib Rules
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(set-cookie, blur_nsfw, off)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(set-cookie, blur_spoiler, on)"

        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(trusted-set-cookie, comment_sort, top)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(trusted-set-cookie, post_sort, hot)"

        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(trusted-set-cookie, theme, black, , , reload, 1)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(trusted-set-cookie, video_quality, medium)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(set-cookie, fixed_navbar, off)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(set-cookie, use_hls, on)"
        "lr.ptr.moe,redlib.perennialte.ch,redlib.catsarch.com##+js(set-cookie, disable_visit_reddit_confirmation, off)"

        # Nitter Rules
        "xcancel.com,nitter.net##+js(set-cookie, infiniteScroll, on)"
        "xcancel.com,nitter.net##+js(trusted-set-cookie, theme, black)"
      ];
      filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "adguard-spyware-url"
        "block-lan"
        "fanboy-cookiemonster"
        "ublock-cookies-easylist"
        "fanboy-social"
        "easylist-chat"
        "easylist-newsletters"
        "easylist-notifications"
        "easylist-annoyances"
        "ublock-annoyances"

        "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
        "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"

        "https://gitlab.com/DandelionSprout/adfilt/-/raw/master/AnnoyancesList"
        "https://github.com/easylist/easylist/raw/refs/heads/master/fanboy-addon/fanboy_ai_suggestions.txt"

        "https://github.com/yokoffing/filterlists/raw/main/annoyance_list.txt"
        "https://github.com/yokoffing/filterlists/raw/refs/heads/main/privacy_essentials.txt"
        "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/block_third_party_fonts.txt"

        # Phoenix/BadBlock
        "beacon" # https://gitlab.com/celenityy/Phoenix/-/raw/pages/uBlock/beacon.txt

        "ublock-webgl" # https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/block-webgl.txt
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/unbreak-webgl.txt"

        "webrtc" # https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/block-webrtc.txt
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/unbreak-webrtc.txt"

        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/block-webgpu.txt"
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/unbreak-webgpu.txt"

        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/abp/badblock_plus.txt"
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/abp/fonts.txt"
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/abp/click-tracking.txt"
        "https://gitlab.com/celenityy/BadBlock/-/raw/pages/hardened/block-page-visibility.txt"
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
        "true"
      ]
      [
        "popupPanelSections"
        "31"
      ]
      [
        "userFiltersTrusted"
        "true"
      ]
    ];
  };
}
