user_pref("layout.css.visited_links_enabled", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.cpd.history", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");
user_pref("browser.pagethumbnails.capturing_disabled", true);
user_pref("layout.frame_rate", 90);

// Other tweaks
user_pref("browser.toolbars.bookmarks.visibility", "newtab");
user_pref("browser.backspace_action", 0);
user_pref("browser.uidensity", 1);
user_pref("browser.tabs.insertAfterCurrent", true);

//FastFox
user_pref("nglayout.initialpaint.delay", 1000); // for darkreader

user_pref("gfx.webrender.all", true); // enables WR + additional features
user_pref("gfx.webrender.precache-shaders", true); // longer initial startup time
user_pref("gfx.webrender.compositor", true); // DEFAULT WINDOWS macOS
user_pref("gfx.webrender.program-binary-disk", true);

user_pref("layers.gpu-process.enabled", true); // DEFAULT WINDOWS
user_pref("media.gpu-process-decoder", true); // DEFAULT WINDOWS

user_pref("privacy.query_stripping.strip_list", "__hsfp __hssc __hstc __s _bhlid _branch_match_id _branch_referrer _gl _hsenc _kx _openstat at_recipient_id at_recipient_list bbeml bsft_clkid bsft_uid dclid et_rid fb_action_ids fb_comment_id fbclid gclid guce_referrer guce_referrer_sig hsCtaTracking irclickid mc_eid ml_subscriber ml_subscriber_hash msclkid mtm_cid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id pk_cid rb_clickid s_cid sc_customer sc_eh sc_uid sms_click sms_source sms_uph srsltid ss_email_id syclid ttclid twclid unicorn_click_id vero_conv vero_id vgo_ee wbraid wickedid yclid ymclid ysclid") // https://github.com/brave/brave-core/blob/master/components/query_filter/utils.cc

user_pref("browser.cache.jsbc_compression_level", 3);

// LIBREWOLF SETTINGS

// /** [SECTION] CACHE AND STORAGE */
user_pref("browser.shell.shortcutFavicons", false); // disable favicons in profile folder
user_pref("browser.helperApps.deleteTempFileOnExit", true); // delete temporary files opened with external apps
//
// /** [SECTION] HISTORY AND SESSION RESTORE
//  * since we hide the UI for modes other than custom we want to reset it for
//  * everyone. same thing for always on PB mode.
//  */
user_pref("privacy.history.custom", true);
user_pref("browser.formfill.enable", false); // disable form history
user_pref("browser.sessionstore.privacy_level", 2); // prevent websites from storing session data like cookies and forms
//

/** [SECTION] WEBRTC
 * there is no point in disabling webrtc as mDNS protects the private IP on linux, osx and win10+.
 * the private IP address is only used in trusted environments, eg. allowed camera and mic access.
 */
user_pref("media.peerconnection.ice.default_address_only", true); // use a single interface for ICE candidates, the vpn one when a vpn is used

/** [SECTION] RFP
 * librewolf should stick to RFP for fingerprinting. we should not set prefs that interfere with it
 * and disabling API for no good reason will be counter productive, so it should also be avoided.
 */
// rfp related settings
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true); // prevents rfp from breaking AMO

/** [SECTION] CERTIFICATES */
user_pref("security.cert_pinning.enforcement_level", 2); // enable strict public key pinning, might cause issues with AVs
/** enable safe negotiation and show warning when it is not supported. might cause breakage
 * if the the server does not support RFC 5746, in tha case SSL_ERROR_UNSAFE_NEGOTIATION
 * will be shown.
 */
user_pref("security.ssl.require_safe_negotiation", true);

/** [SECTION] SAFE BROWSING
 * disable safe browsing, including the fetch of updates. reverting the 7 prefs below
 * allows to perform local checks and to fetch updated lists from google.
 */
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");
/** disable safe browsing checks on downloads, both local and remote. the resetting prefs
 * control remote checks, while the first one is for local checks only.
 */
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
// empty for defense in depth
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");

/** [SECTION] LOCATION
 * replace google with beacondb as the default geolocation provide and prevent use of OS location services
 */
user_pref("geo.provider.use_gpsd", false); // [LINUX]

/** [SECTION] LANGUAGE
 * show language as en-US for all users, regardless of their OS language and browser language.
 * both prefs must use pref() and not defaultPref to work.
 */
//pref("javascript.use_us_english_locale", true);
//pref("intl.accept_languages", "en-US, en");
// disable region specific updates from mozilla
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

/** [SECTION] DRM */
user_pref("media.eme.enabled", false); // master switch for drm content
user_pref("media.gmp-manager.url", "data:text/plain,"); // prevent checks for plugin updates when drm is disabled
// disable the widevine and the openh264 plugins
user_pref("media.gmp-provider.enabled", false);
user_pref("media.gmp-gmpopenh264.enabled", false);
// but allow h264 itself.
user_pref("media.webrtc.hw.h264.enabled", true);

/** [SECTION] SEARCH AND URLBAR
 * disable search suggestion and do not update opensearch engines.
 */
user_pref("browser.search.serpEventTelemetryCategorization.enabled", false);
user_pref("browser.urlbar.suggest.amp", false);
user_pref("browser.urlbar.suggest.mdn", true);

// Allows the user to add a custom search engine in the settings.
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

/** [SECTION] DOWNLOADS
 * user interaction should always be required for downloads, as a way to enhance security by asking
 * the user to specific a certain save location.
 */
user_pref("browser.download.alwaysOpenPanel", false); // do not expand toolbar menu for every download, we already have enough interaction

/** [SECTION] AUTOPLAY
 * block autoplay unless element is right-clicked. this means background videos, videos in a different tab,
 * or media opened while other media is played will not start automatically.
 * thumbnails will not autoplay unless hovered. exceptions can be set from the UI.
 */
user_pref("media.autoplay.default", 5);

/** [SECTION] POP-UPS AND WINDOWS
 * prevent scripts from resizing existing windows and opening new ones, by forcing them into
 * new tabs that can't be resized as well.
 */
user_pref("dom.disable_window_move_resize", true);
user_pref("browser.link.open_newwindow.restriction", 0);

/** [SECTION] MOUSE */
user_pref("browser.tabs.searchclipboardfor.middleclick", false); // prevent mouse middle click on new tab button to trigger searches or page loads

/** [SECTION] MACHINE LEARNING **/
// See ticket: #1919 - LibreWolf should delete all AI code - https://codeberg.org/librewolf/issues/issues/1919
user_pref("browser.ml.linkPreview.supportedLocales", "null");
user_pref("extensions.ui.mlmodel.hidden", true);
// disable smart tab groups
user_pref("browser.tabs.groups.smart.userEnabled", false);

/** ------------------------------
 * [CATEGORY] EXTENSIONS
 * ------------------------------- */

/** [SECTION] USER INSTALLED
 * extensions are allowed to operate on restricted domains, while their scope
 * is set to profile+applications (https://mike.kaply.com/2012/02/21/understanding-add-on-scopes/).
 * an installation prompt should always be displayed.
 */
user_pref("extensions.webextensions.restrictedDomains", "");
user_pref("extensions.postDownloadThirdPartyPrompt", false);

/** [SECTION] SYSTEM
 * built-in extension are not allowed to auto-update. additionally the reporter extension
 * of webcompat is disabled. urls are stripped for defense in depth.
 */
// user_pref("extensions.systemAddon.update.enabled", false);
// user_pref("extensions.systemAddon.update.url", "");
// user_pref("extensions.webcompat-reporter.enabled", false);
// user_pref("extensions.webcompat-reporter.newIssueEndpoint", "");

/** ------------------------------
 * [CATEGORY] BUILT-IN FEATURES
 * ------------------------------- */

/** [SECTION] UPDATER
 * since we do not bake auto-updates in the browser it doesn't make sense at the moment.
 */
user_pref("app.update.auto", false);
/** [SECTION] LOCKWISE
 * disable the default password manager built into the browser, including its autofill
 * capabilities and formless login capture.
 */
user_pref("signon.autofillForms", false);

/** [SECTION] CONTAINERS
 * enable containers and show the settings to control them in the stock ui
 */
user_pref("privacy.userContext.enabled", true);

/** [SECTION] DEVTOOLS
 * disable remote debugging.
 */
user_pref("devtools.selfxss.count", 0); // required for devtools console to work

/** ------------------------------
 * [CATEGORY] UI
 * ------------------------------- */
/** [SECTION] FIRST LAUNCH
 * disable what's new, ui tour, and privacy notice/terms of use on first start and updates. the browser
 * should also not stress user about being the default one.
 */
user_pref("browser.uitour.url", "");
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 999);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "32503679999000"
);
user_pref("startup.homepage_override_nimbus_disable_wnp", true);
user_pref("termsofuse.acceptedDate", "32503679999000");
user_pref("termsofuse.acceptedVersion", 999);
user_pref("termsofuse.bypassNotification", true);

/** [SECTION] NEW TAB PAGE
 * we want NTP to display nothing but the search bar without anything distracting.
 * the three prefs below are just for minimalism and they should be easy to revert for users.
 */
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
// hide stories UI in about:preferences#home, empty highlights list
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories.options", '{"hidden":true}');

/** [SECTION] ABOUT
 * remove annoying ui elements from the about pages, including about:protections
 */
user_pref("browser.contentblocking.report.lockwise.enabled", false);
user_pref("browser.contentblocking.report.hide_vpn_banner", true);
user_pref("browser.contentblocking.report.vpn.enabled", false);
user_pref("browser.contentblocking.report.show_mobile_app", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("browser.promo.focus.enabled", false);
// ...about:addons recommendations sections and more
user_pref("lightweightThemes.getMoreURL", ""); // disable button to get more themes
// ...about:preferences#home
user_pref("browser.topsites.useRemoteSetting", false); // hide sponsored shortcuts button

/** [SECTION] OTHERS
 * other unwanted UI
 */
// hide pxi ads on toolbar firefox sync button
user_pref("identity.fxaccounts.toolbar.pxiToolbarEnabled", false);
// remove the "send to device" tab by default from opt-in sidebar layout
user_pref("sidebar.main.tools", "history");

/** ------------------------------
 * [CATEGORY] TELEMETRY
 * telemetry is already disabled elsewhere and most of the stuff in here is just for redundancy.
 * ------------------------------- */
user_pref("toolkit.telemetry.cachedClientID", "");
user_pref("toolkit.telemetry.previousBuildID", "");
user_pref("toolkit.telemetry.server_owner", "");
user_pref("toolkit.coverage.enabled", false);
// disable connectivity checks
user_pref("network.connectivity-service.enabled", false);
// disable captive portal
user_pref("network.captive-portal-service.enabled", false);
user_pref("captivedetect.canonicalURL", "");
// disable Privacy-Preserving Attribution
user_pref("dom.private-attribution.submission.enabled", false);
