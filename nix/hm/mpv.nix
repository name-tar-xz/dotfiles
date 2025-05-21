{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ani-cli
    ani-skip
    aria
  ];
  programs = {
    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        autodeint
        mpris
        pkgs.ani-skip
      ];
      config = {
        hwdec = "vaapi,auto-safe";
        vo = "gpu-next,gpu,auto";
        ao = "pipewire,";
        gpu-context = "wayland";
        deband = true;
        audio-spdif = [
          "ac3"
          "eac3"
          "dts-hd"
          "truehd"
        ];
        sub-font = "monospace";
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
      settings = {
        downloader = "aria2c";
        downloader-args = "'-c -j 6 -x 6 -s 6 -k 1M'";
      };
    };
  };
}
