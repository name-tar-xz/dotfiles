{ ... }:
{
  boot = {
    kexec.enable = false;
    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    kernelParams = [ "debugfs=off" ];

    kernel.sysctl = {
      "kernel.kptr_restrict" = 2;
      "kernel.ftrace_enabled" = false;

      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;

      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = 1;
    };
  };

  systemd.settings.Manager.DumpCore = false;

  security = {
    protectKernelImage = true;
    lockKernelModules = true;
    loginDefs.settings.UMASK = "022";
    pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "core";
        value = 0;
      }
      {
        domain = "*";
        type = "soft";
        item = "core";
        value = 0;
      }
    ];
  };
}
