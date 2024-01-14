user_pref("browser.startup.page", 3);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);
user_pref("network.trr.mode", 5);
user_pref("layout.css.visited_links_enabled", false);
user_pref("browser.download.always_ask_before_handling_new_types", false);
user_pref("privacy.antitracking.enableWebcompat", true);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.cpd.history", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
// user_pref("privacy.resistFingerprinting", false);
user_pref("webgl.disabled", false);
user_pref("signon.rememberSignons", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");
user_pref("browser.pagethumbnails.capturing_disabled", true);
user_pref("network.http.referer.XOriginPolicy", 1);
user_pref("browser.search.separatePrivateDefault", false);

// Other tweaks
user_pref("browser.toolbars.bookmarks.visibility", "newtab");
user_pref("browser.backspace_action", 0);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);
user_pref("browser.tabs.insertAfterCurrent", true);
user_pref("browser.urlbar.trimHttps", true);

//FastFox

user_pref("gfx.webrender.all", true); // enables WR + additional features
user_pref("gfx.webrender.precache-shaders", true); // longer initial startup time
user_pref("gfx.webrender.compositor", true); // DEFAULT WINDOWS macOS
user_pref("gfx.webrender.compositor.force-enabled", true); // enforce

user_pref("layers.gpu-process.enabled", true); // DEFAULT WINDOWS
user_pref("layers.gpu-process.force-enabled", true); // enforce
user_pref("layers.mlgpu.enabled", true); // LINUX
user_pref("media.hardware-video-decoding.enabled", true); // DEFAULT WINDOWS macOS
user_pref("media.hardware-video-decoding.force-enabled", true); // enforce
user_pref("media.gpu-process-decoder", true); // DEFAULT WINDOWS
user_pref("media.ffmpeg.vaapi.enabled", true); // LINUX

user_pref("media.av1.enabled", false);

user_pref("browser.cache.disk.enable", false);
