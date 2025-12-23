{ pkgs, inputs, ... }:
{
  imports = [ ./ublock.nix ];

  home.file.".mozilla/firefox/main/chrome/csshacks".source = inputs.csshacks;

  services.psd = {
    enable = true;
    browsers = [ "firefox" ];
    backupLimit = 3;
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.firefox-bin;

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;

      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      ShowHomeButton = false;

      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      PromptForDownloadLocation = true;
      StartDownloadsInTempDirectory = true;
      SearchBar = "unified";

      HardwareAcceleration = true;
      HttpsOnlyMode = "force_enabled";
      DisableEncryptedClientHello = false;
      NetworkPrediction = false;
      SearchSuggestEnabled = false;
      TranslateEnabled = true;

      DisableSecurityBypass.InvalidCertificate = true;
      FirefoxSuggest.WebSuggestions = false;
      GenerativeAI.Enabled = false;
      Homepage.StartPage = "previous-session";

      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };

      EnableTrackingProtection = {
        Category = "strict";
        Value = true;
        Locked = true;
        BaselineExceptions = true;
        ConvenienceExceptions = false;
      };

      ExtensionSettings =
        let
          # shortId: https://addons.mozilla.org/en-US/firefox/addon/${shortId}/ uuid: about:support
          extension = shortId: uuid: private: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
              private_browsing = private;
            };
          };
        in
        builtins.listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net" true)
          (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me" true)
          (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me" false)
          (extension "darkreader" "addon@darkreader.org" true)
          (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" true)
          (extension "chameleon-ext" "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}" false)
        ];

      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Stories = false;
        SponsoredStories = false;
        Snippets = false;
        Locked = true;
      };

      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        Allow = builtins.concatLists (
          map
            (elem: [
              ("http://" + elem)
              ("https://" + elem)
            ])
            [
              "account.proton.me"
              "app.cinny.in"
              "app.element.io"
              "github.com"
              "gitlab.com"
            ]
        );
        Locked = true;
      };

      Handlers.schemes.mailto = {
        action = "useHelperApp";
        ask = false;
        handlers = [
          {
            name = "ProtonMail";
            uriTemplate = "https://mail.proton.me/inbox/#mailto=%s";
          }
        ];
      };

      Permissions.Notifications.Allow = [
        "https://app.cinny.in"
        "https://app.element.io"
        "https://mail.proton.me"
      ];

      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        FormData = false;
        History = false;
        Sessions = true;
        SiteSettings = false;
        Locked = true;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
    };

    profiles = {
      main = {
        search = {
          default = "Brave";
          force = true;
          engines = {
            Brave = {
              name = "Brave";
              urls = [
                {
                  template = "https://search.brave.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            perplexity.metaData.hidden = true;
          };
        };

        settings = {
          "layout.css.visited_links_enabled" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.cpd.history" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
          "browser.pagethumbnails.capturing_disabled" = true;
          "layout.frame_rate" = 90;

          # Other tweaks
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.backspace_action" = 0;
          "browser.uidensity" = 1;
          "browser.tabs.insertAfterCurrent" = true;

          "nglayout.initialpaint.delay" = 1000; # for darkreader

          "gfx.webrender.all" = true; # enables WR + additional features
          "gfx.webrender.precache-shaders" = true; # longer initial startup time
          "gfx.webrender.compositor" = true;
          "gfx.webrender.program-binary-disk" = true;

          "layers.gpu-process.enabled" = true;
          "media.gpu-process-decoder" = true;

          "browser.cache.jsbc_compression_level" = 3;

          "privacy.query_stripping.strip_list" = # https://github.com/brave/brave-core/blob/master/components/query_filter/utils.cc
            "__hsfp __hssc __hstc __s _bhlid _branch_match_id _branch_referrer _gl _hsenc _kx _openstat at_recipient_id at_recipient_list bbeml bsft_clkid bsft_uid dclid et_rid fb_action_ids fb_comment_id fbclid gclid guce_referrer guce_referrer_sig hsCtaTracking irclickid mc_eid ml_subscriber ml_subscriber_hash msclkid mtm_cid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id pk_cid rb_clickid s_cid sc_customer sc_eh sc_uid sms_click sms_source sms_uph srsltid ss_email_id syclid ttclid twclid unicorn_click_id vero_conv vero_id vgo_ee wbraid wickedid yclid ymclid ysclid";

          # LIBREWOLF SETTINGS https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
          "browser.shell.shortcutFavicons" = false; # disable favicons in profile folder
          "browser.helperApps.deleteTempFileOnExit" = true; # delete temporary files opened with external apps

          # /** [SECTION] HISTORY AND SESSION RESTORE
          #  * since we hide the UI for modes other than custom we want to reset it for
          #  * everyone. same thing for always on PB mode.
          #  */
          "privacy.history.custom" = true;
          "browser.formfill.enable" = false; # disable form history
          "browser.sessionstore.privacy_level" = 2; # prevent websites from storing session data like cookies and forms

          "media.peerconnection.ice.default_address_only" = true; # use a single interface for ICE candidates, the vpn one when a vpn is used

          "privacy.resistFingerprinting.block_mozAddonManager" = true; # prevents rfp from breaking AMO

          "security.cert_pinning.enforcement_level" = 2; # enable strict public key pinning, might cause issues with AVs
          /**
            enable safe negotiation and show warning when it is not supported. might cause breakage
            if the the server does not support RFC 5746, in tha case SSL_ERROR_UNSAFE_NEGOTIATION
            will be shown.
          */
          "security.ssl.require_safe_negotiation" = true;

          /**
            [SECTION] SAFE BROWSING
            disable safe browsing, including the fetch of updates. reverting the 7 prefs below
            allows to perform local checks and to fetch updated lists from google.
          */
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.provider.google4.gethashURL" = "";
          "browser.safebrowsing.provider.google4.updateURL" = "";
          "browser.safebrowsing.provider.google.gethashURL" = "";
          "browser.safebrowsing.provider.google.updateURL" = "";
          /**
            disable safe browsing checks on downloads, both local and remote. the resetting prefs
            control remote checks, while the first one is for local checks only.
          */
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          # empty for defense in depth
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.provider.google4.dataSharingURL" = "";

          # disable region specific updates from mozilla
          "browser.region.network.url" = "";
          "browser.region.update.enabled" = false;

          # [SECTION] DRM
          "media.eme.enabled" = false; # master switch for drm content
          "media.gmp-manager.url" = "data:text/plain,"; # prevent checks for plugin updates when drm is disabled
          # disable the widevine and the openh264 plugins
          "media.gmp-provider.enabled" = false;
          "media.gmp-gmpopenh264.enabled" = false;
          "media.webrtc.hw.h264.enabled" = true; # but allow h264 itself.

          /**
            [SECTION] SEARCH AND URLBAR
            disable search suggestion and do not update opensearch engines.
          */
          "browser.search.serpEventTelemetryCategorization.enabled" = false;
          "browser.urlbar.suggest.amp" = false;
          "browser.urlbar.suggest.mdn" = true;

          "browser.urlbar.update2.engineAliasRefresh" = true; # Allows the user to add a custom search engine in the settings.

          "browser.download.alwaysOpenPanel" = false; # do not expand toolbar menu for every download, we already have enough interaction

          /**
            [SECTION] AUTOPLAY
            block autoplay unless element is right-clicked. this means background videos, videos in a different tab,
            or media opened while other media is played will not start automatically.
            thumbnails will not autoplay unless hovered. exceptions can be set from the UI.
          */
          "media.autoplay.default" = 5;

          /**
            [SECTION] POP-UPS AND WINDOWS
            prevent scripts from resizing existing windows and opening new ones, by forcing them into
            new tabs that can't be resized as well.
          */
          "dom.disable_window_move_resize" = true;
          "browser.link.open_newwindow.restriction" = 0;

          "browser.tabs.searchclipboardfor.middleclick" = false; # prevent mouse middle click on new tab button to trigger searches or page loads

          # [SECTION] MACHINE LEARNING
          "browser.ml.linkPreview.supportedLocales" = "null";
          "extensions.ui.mlmodel.hidden" = true;
          "browser.tabs.groups.smart.userEnabled" = false; # disable smart tab groups

          /**
            [SECTION] USER INSTALLED
            extensions are allowed to operate on restricted domains, while their scope
            is set to profile+applications (https:#mike.kaply.com/2012/02/21/understanding-add-on-scopes/).
            an installation prompt should always be displayed.
          */
          "extensions.webextensions.restrictedDomains" = "";
          "extensions.postDownloadThirdPartyPrompt" = false;

          "privacy.userContext.enabled" = true; # enable containers and show the settings to control them in the stock ui

          "devtools.selfxss.count" = 0; # required for devtools console to work

          /**
            [SECTION] FIRST LAUNCH
            disable what's new, ui tour, and privacy notice/terms of use on first start and updates. the browser
            should also not stress user about being the default one.
          */
          "browser.uitour.url" = "";
          "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 999;
          "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
          "datareporting.policy.dataSubmissionPolicyNotifiedTime" = "32503679999000";
          "startup.homepage_override_nimbus_disable_wnp" = true;
          "termsofuse.acceptedDate" = "32503679999000";
          "termsofuse.acceptedVersion" = 999;
          "termsofuse.bypassNotification" = true;

          /**
            [SECTION] NEW TAB PAGE
            we want NTP to display nothing but the search bar without anything distracting.
            the three prefs below are just for minimalism and they should be easy to revert for users.
          */
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;

          "browser.newtabpage.activity-stream.feeds.section.topstories.options"."hidden" = true; # hide stories UI in about:preferences#home, empty highlights list

          /**
            [SECTION] ABOUT
            remove annoying ui elements from the about pages, including about:protections
          */
          "browser.contentblocking.report.lockwise.enabled" = false;
          "browser.contentblocking.report.hide_vpn_banner" = true;
          "browser.contentblocking.report.vpn.enabled" = false;
          "browser.contentblocking.report.show_mobile_app" = false;
          "browser.vpn_promo.enabled" = false;
          "browser.promo.focus.enabled" = false;
          # ...about:addons recommendations sections and more
          "lightweightThemes.getMoreURL" = ""; # disable button to get more themes
          # ...about:preferences#home
          "browser.topsites.useRemoteSetting" = false; # hide sponsored shortcuts button

          "identity.fxaccounts.toolbar.pxiToolbarEnabled" = false; # hide pxi ads on toolbar firefox sync button
          "sidebar.main.tools" = "history"; # remove the "send to device" tab by default from opt-in sidebar layout

          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.previousBuildID" = "";
          "toolkit.telemetry.server_owner" = "";
          "toolkit.coverage.enabled" = false;

          "network.connectivity-service.enabled" = false; # disable connectivity checks
          "dom.private-attribution.submission.enabled" = false; # disable Privacy-Preserving Attribution
          # disable captive portal
          "network.captive-portal-service.enabled" = false;
          "captivedetect.canonicalURL" = "";
        };

        preConfig = builtins.readFile "${inputs.betterfox}/user.js";

        userChrome = ./chrome/userChrome.css;
        userContent = ./chrome/userContent.css;
      };
    };
  };
}
