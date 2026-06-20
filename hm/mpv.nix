{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    (ani-cli.override { mpv = config.programs.mpv.package; })
    ani-skip
    aria2
  ];
  programs = {
    mpv = {
      enable = true;
      package = pkgs.mpv.override {
        yt-dlp = config.programs.yt-dlp.package;
        scripts = with pkgs.mpvScripts; [
          autodeint
          mpris
          (pkgs.ani-skip.overrideAttrs { passthru.scriptName = "skip"; })
        ];
      };
      config = {
        hwdec = "vaapi,auto-safe";
        vo = "gpu-next,gpu,auto";
        ao = "pipewire,";
        gpu-context = "wayland";
        deband = true;
        sub-font = "serif";
        osd-font = "monospace";
        cache = true;
        speed = 2;
        volume-max = 100;
        hls-bitrate = "max";

        cursor-autohide = 200;
        cursor-autohide-fs-only = true;
        msg-color = true;
        msg-module = true;
        term-osd-bar = true;
      };
      scriptOpts.ytdl_hook.try_ytdl_first = true;
    };

    yt-dlp = {
      enable = true;
      package = (pkgs.yt-dlp.override { jsRuntime = pkgs.nodejs; }).overrideAttrs (prev: {
        mkWrapperArgs = prev.makeWrapperArgs or [ ] ++ [
          "--add-flag"
          "--js-runtimes=node"
        ];
      });
      settings = {
        downloader = "aria2c";
        downloader-args = "'-c -j 6 -x 6 -s 6 -k 1M'";
      };
    };
  };
}
