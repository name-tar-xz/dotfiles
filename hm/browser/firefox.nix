{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
{
  imports = [ ./ublock.nix ];

  xdg.configFile = {
    "mozilla/firefox/main/chrome/csshacks".source = inputs.csshacks;
    "mozilla/firefox/main/customKeys.json".text = builtins.toJSON { key_inspector = { }; };
  };

  home = {
    file.".mozilla/native-messaging-hosts".enable = false;

    activation.removeMozilla = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run rm -rf ${
        lib.attrsets.filterAttrs (n: v: lib.strings.hasPrefix config.programs.firefox.configPath n) config.home.file
        |> lib.attrsets.mapAttrsToList (n: v: "${n} ${n}.bak")
        |> toString
      }
    '';

    packages =
      ((inputs.nixpak.lib.nixpak { inherit (pkgs) lib pkgs; }) {
        config = { ... }: rec {
          imports = (import ./nixPakBrowser.nix) { inherit osConfig config; } |> lib.singleton;

          app.package = config.programs.firefox.finalPackage;
          etc.sslCertificates.enable = (builtins.elemAt app.package.meta.sourceProvenance 0).isSource; # Certs not needed for binary packages
          flatpak.appId = "org.mozilla.firefox";
          dbus.policies = {
            # From Firefox Flatpak Metadata (path after installing ff flatpak: XDG_DATA_HOME/flatpak/app/org.mozilla.firefox/current/active/metadata)
            "org.mozilla.firefox.*" = "own";
            "org.gtk.vfs.*" = "talk"; # ?
            "org.mpris.MediaPlayer2.firefox.*" = "own";
            "org.a11y.Bus" = "talk";
            "org.freedesktop.FileManager1" = "talk";
          };

          bubblewrap = {
            bind = with config.xdg; {
              rw = [
                [
                  "${configHome}/mozilla/firefox"
                  "${config.home.homeDirectory}/.config/mozilla/firefox"
                ]
                [
                  "${cacheHome}/mozilla/firefox"
                  "${config.home.homeDirectory}/.cache/mozilla/firefox"
                ]
              ];

              ro =
                lib.attrsets.filterAttrs (n: _: lib.strings.hasPrefix config.programs.firefox.configPath n) config.home.file
                |> lib.attrsets.mapAttrsToList (
                  n: v: [
                    "${v.source}"
                    n
                  ]
                );
            };
          };
        };
      }).config.env.override
        { meta.priority = -1; }
      |> lib.singleton;
  };

  services.psd = {
    enable = true;
    browsers = [ "firefox" ];
    backupLimit = 3;
  };

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    languagePacks = [ "en-US" ];
    package = pkgs.firefox-bin.override {
      cfg = {
        speechSynthesisSupport = false;
        pipewireSupport = true;
      };
    };

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
      GenerativeAI = {
        Enabled = false;
        Locked = true;
      };
      Homepage = {
        StartPage = "previous-session";
        Locked = true;
      };

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
            "${uuid}" = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
              private_browsing = private;
            };
          };
        in
        lib.mkMerge [
          (extension "ublock-origin" "uBlock0@raymondhill.net" true)
          (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me" true)
          (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me" false)
          (extension "darkreader" "addon@darkreader.org" true)
          (extension "scriptcat" "{8e515334-52b5-4cc5-b4e8-675d50af677d}" true)
          (extension "chameleon-ext" "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}" false)
        ];

      FirefoxHome = {
        Search = false;
        TopSites = false;
        Locked = true;
      };

      Cookies = {
        Allow =
          [
            "account.proton.me"
            "auth.adguardaccount.com"
            "auth.ente.io"

            "app.cinny.in"
            "app.sable.moe"
            "app.element.io"

            "anilist.co"
            "anichart.net"

            "github.com"
            "gitlab.com"
            "codeberg.org"
            "git.gay"
          ]
          |> map (sites: [
            ("http://" + sites)
            ("https://" + sites)
          ])
          |> builtins.concatLists;
        Locked = true;
      };

      Handler.schemes.mailto = {
        action = "useHelperApp";
        ask = false;
        handlers = lib.singleton {
          name = "ProtonMail";
          uriTemplate = "https://mail.proton.me/inbox/#mailto=%s";
        };
      };

      Permissions.Notifications.Allow = [
        "https://app.cinny.in"
        "https://app.sable.moe"
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

      UserMessaging.Locked = true; # Set by Phoenix
    };

    profiles = {
      main = {
        search = {
          default = "Brave";
          force = true;
          engines = {
            Brave = {
              name = "Brave";
              urls = lib.singleton {
                template = "https://search.brave.com/search";
                params = lib.singleton {
                  name = "q";
                  value = "{searchTerms}";
                };
              };
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

          "media.webrtc.camera.allow-pipewire" = true;

          "dom.webgpu.enabled" = true;

          "privacy.spoof_english" = 2;

          "network.trr.mode" = 5;

          "extensions.webextensions.base-content-security-policy.v3" = # for proton-pass
            "script-src 'self' 'wasm-unsafe-eval'; upgrade-insecure-requests;";

          "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
          "privacy.clearOnShutdown.history" = false;
          "privacy.cpd.history" = false;
          "privacy.resistFingerprinting.letterboxing" = false;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets";
          "layout.frame_rate" = 90;

          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.backspace_action" = 0;
          "browser.uidensity" = 1;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.urlbar.suggest.history" = true;

          "nglayout.initialpaint.delay" = 1000; # for darkreader

          "gfx.webrender.precache-shaders" = true; # longer initial startup time
          "gfx.webrender.program-binary-disk" = true;

          "layers.gpu-process.enabled" = true;
          "media.gpu-process-decoder" = true;

          "browser.uiCustomization.state" = builtins.toJSON {
            currentVersion = 23;
            dirtyAreaCache = [
              "unified-extensions-area"
              "nav-bar"
              "TabsToolbar"
              "vertical-tabs"
              "toolbar-menubar"
              "PersonalToolbar"
            ];
            newElementCount = 1;
            placements = {
              PersonalToolbar = [ "personal-bookmarks" ];
              TabsToolbar = [ ];
              nav-bar = [
                "reset-pbm-toolbar-button"
                "urlbar-container"
                "downloads-button"
                "unified-extensions-button"
                "vertical-spacer"
                "forward-button"
                "back-button"
              ];
              toolbar-menubar = [ "menubar-items" ];
              unified-extensions-area = [
                "ublock0_raymondhill_net-browser-action"
                "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
                "7esoorv3_alefvanoon_anonaddy_me-browser-action"
                "addon_darkreader_org-browser-action"
                "_8e515334-52b5-4cc5-b4e8-675d50af677d_-browser-action"
                "_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action"
              ];
              vertical-tabs = [ "tabbrowser-tabs" ];
              widget-overflow-fixed-list = [ ];
            };
            seen = [
              "reset-pbm-toolbar-button"
              "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
              "7esoorv3_alefvanoon_anonaddy_me-browser-action"
              "addon_darkreader_org-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_8e515334-52b5-4cc5-b4e8-675d50af677d_-browser-action"
              "developer-button"
              "screenshot-button"
              "_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action"
            ];
          };

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

        userChrome = chrome/userChrome.css;
        userContent = chrome/userContent.css;
      };
    };
  };
}
