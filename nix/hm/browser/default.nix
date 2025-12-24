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
      DisableSetDesktopBackground = true;

      DisplayBookmarksToolbar = "newtab";
      DisplayMenuBar = "default-off";
      ShowHomeButton = false;

      DontCheckDefaultBrowser = true;
      PromptForDownloadLocation = true;
      StartDownloadsInTempDirectory = true;
      SearchBar = "unified";

      HardwareAcceleration = true;
      DisableEncryptedClientHello = false;
      NetworkPrediction = false;
      SearchSuggestEnabled = false;
      TranslateEnabled = true;

      DisableSecurityBypass.InvalidCertificate = true;
      GenerativeAI.Enabled = false;
      Homepage.StartPage = "previous-session";

      DNSOverHTTPS = {
        Enabled = false;
        Locked = false;
      };

      EnableTrackingProtection = {
        Category = "strict";
        Locked = true;
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
        Locked = true;
      };

      Cookies = {
        Allow = builtins.concatLists (
          map
            (sites: [
              ("http://" + sites)
              ("https://" + sites)
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
          "layout.css.prefers-color-scheme.content-override" = 0;
          "sidebar.animation.enabled" = true;
          "ui.panelAnimations" = 1;
          "ui.prefersReducedMotion" = 0;
          "ui.swipeAnimationEnabled" = 1;

          "dom.webgpu.enabled" = true;

          "privacy.spoof_english" = 2;

          "network.trr.mode" = 5;

          "extensions.webextensions.base-content-security-policy.v3" = # for proton-pass
            "cript-src 'self' 'wasm-unsafe-eval'; upgrade-insecure-requests;";

          "privacy.clearOnShutdown.history" = false;
          "privacy.cpd.history" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "layout.frame_rate" = 90;

          # Other tweaks
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.backspace_action" = 0;
          "browser.uidensity" = 1;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.tabs.hoverPreview.enabled" = true;

          "nglayout.initialpaint.delay" = 1000; # for darkreader

          "gfx.webrender.precache-shaders" = true; # longer initial startup time
          "gfx.webrender.program-binary-disk" = true;

          "layers.gpu-process.enabled" = true;
          "media.gpu-process-decoder" = true;

          # LIBREWOLF SETTINGS https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
          "extensions.ui.mlmodel.hidden" = true;
          "devtools.selfxss.count" = 0; # required for devtools console to work

          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        };

        preConfig = builtins.readFile "${inputs.betterfox}/user.js";

        userChrome = ./chrome/userChrome.css;
        userContent = ./chrome/userContent.css;
      };
    };
  };
}
