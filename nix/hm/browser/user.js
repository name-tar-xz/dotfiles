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
user_pref("browser.uidensity", 1);
user_pref("browser.tabs.insertAfterCurrent", true);

//FastFox
user_pref("nglayout.initialpaint.delay", 1000); // for darkreader

user_pref("gfx.webrender.all", true); // enables WR + additional features
user_pref("gfx.webrender.precache-shaders", true); // longer initial startup time
user_pref("gfx.webrender.compositor", true); // DEFAULT WINDOWS macOS
user_pref("gfx.webrender.compositor.force-enabled", true); // enforce
user_pref("gfx.webrender.program-binary-disk", true);

user_pref("gfx.canvas.accelerated", true); // DEFAULT macOS LINUX [FF110]; not compatible with WINDOWS integrated GPUs
user_pref("gfx.canvas.accelerated.cache-items", 8192); // default=2048; alt=8192
user_pref("gfx.canvas.accelerated.cache-size", 1024); // default=256; alt=1024
user_pref("gfx.content.skia-font-cache-size", 20); // default=5; Chrome=20

user_pref("layers.gpu-process.enabled", true); // DEFAULT WINDOWS
user_pref("layers.gpu-process.force-enabled", true); // enforce
user_pref("layers.mlgpu.enabled", true); // LINUX
user_pref("media.hardware-video-decoding.enabled", true); // DEFAULT WINDOWS macOS
user_pref("media.hardware-video-decoding.force-enabled", true); // enforce
user_pref("media.gpu-process-decoder", true); // DEFAULT WINDOWS
user_pref("media.ffmpeg.vaapi.enabled", true); // LINUX

user_pref("media.av1.enabled", true);

user_pref("gfx.webrender.dcomp-video-hw-overlay-win", true); // DEFAULT
user_pref("gfx.webrender.dcomp-video-hw-overlay-win-force-enabled", true); // enforce
user_pref("gfx.webrender.dcomp-video-sw-overlay-win", true); // DEFAULT
user_pref("gfx.webrender.dcomp-video-sw-overlay-win-force-enabled", true); // enforce

user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.jsbc_compression_level", 3);
user_pref("browser.cache.disk.metadata_memory_limit", 500); // default=250 (0.25 MB); limit of recent metadata we keep in memory for faster access

user_pref("browser.cache.memory.max_entry_size", 10240); // (10 MB); default=5120 (5 MB)
user_pref("browser.sessionhistory.max_total_viewers", 2);

user_pref("media.memory_cache_max_size", 131072); // default=8192; AF=65536; alt=131072
user_pref("media.memory_caches_combined_limit_kb", 1048576); // DEFAULT; alt=1048576
user_pref("media.memory_caches_combined_limit_pc_sysmem", 10); // DEFAULT; alt=10; the percentage of system memory that Firefox can use for media caches

user_pref("media.cache_readahead_limit", 7200); // 120 min; default=60; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 3600); // 60 min; default=30; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold

user_pref("image.cache.size", 10485760); // DEFAULT; in MiB; alt=10485760 (cache images up to 10MiB in size)
user_pref("image.mem.decode_bytes_at_a_time", 65536); // default=16384; alt=65536; chunk size for calls to the image decoders
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000); // default=60000; minimum timeout to unmap shared surfaces since they have been last used

user_pref("network.buffer.cache.size", 262144); // 256 kb; default=32768 (32 kb)
user_pref("network.buffer.cache.count", 128); // default=24

user_pref("network.dnsCacheEntries", 1000); // default=400
user_pref("network.dnsCacheExpirationGracePeriod", 240); // default=60; cache DNS entries for 4 minutes after they expire

user_pref("network.prefetch-next", true);
user_pref("network.fetchpriority.enabled", true);
user_pref("network.predictor.enable-hover-on-ssl", true);
user_pref("network.dns.disablePrefetch", false);
user_pref("network.http.speculative-parallel-limit", 20); // DEFAULT (FF127+?)
user_pref("network.dns.disablePrefetchFromHTTPS", false); // [FF127+ false]

user_pref("dom.ipc.processPrelaunch.fission.number", 1); // default=3; Process Preallocation Cache
user_pref("dom.ipc.processCount.webIsolated", 1); // default=4; Isolated Web Content
