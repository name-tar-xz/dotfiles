{ inputs, ... }:
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

        extraConfig = ''
          ${builtins.readFile "${inputs.betterfox}/user.js"}
          ${builtins.readFile ./user.js}
        '';

        userChrome = ./chrome/userChrome.css;
        userContent = ./chrome/userContent.css;
      };
    };
  };
}
