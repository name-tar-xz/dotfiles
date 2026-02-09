_: {
  boot = {
    kexec.enable = false;
    blacklistedKernelModules = [
      # Obscure network protocols
      "af_802154"
      "appletalk"
      "atm"
      "ax25"
      "can"
      "dccp"
      "decnet"
      "econet"
      "ipx"
      "n-hdlc"
      "netrom"
      "p8022"
      "p8023"
      "psnap"
      "rds"
      "rose"
      "sctp"
      "tipc"
      "x25"

      # Old or rare or insufficiently audited filesystems
      "9p"
      "adfs"
      "affs"
      "afs"
      "befs"
      "bfs"
      "ceph"
      "cifs"
      "coda"
      "cramfs"
      "ecryptfs"
      "efs"
      "exofs"
      "f2fs"
      "freevxfs"
      "gfs2"
      "hfs"
      "hfsplus"
      "hpfs"
      "jffs2"
      "jfs"
      "kafs"
      "ksmbd"
      "minix"
      "nfs"
      "nfsv3"
      "nfsv4"
      "nilfs2"
      "ocfs2"
      "omfs"
      "orangefs"
      "qnx4"
      "qnx6"
      "reiserfs"
      "romfs"
      "squashfs"
      "sysv"
      "ubifs"
      "udf"
      "ufs"
      "zonefs"

      # firewire
      "firewire-core"
      "firewire_core"
      "firewire-ohci"
      "firewire_ohci"
      "firewire_sbp2"
      "firewire-sbp2"
      "firewire-net"

      # disable vivid
      "vivid"

      # disable GNSS
      "gnss"
      "gnss-mtk"
      "gnss-serial"
      "gnss-sirf"
      "gnss-usb"
      "gnss-ubx"

      # block loading joystick driver https://docs.kernel.org/input/joydev/joystick.html
      "joydev"

      # block loading cdrom
      "cdrom"
      "sr_mod"
    ];

    kernelParams = [
      # "debugfs=off" Needed for scx_lavd
      "hash_pointers=always"
      "init_on_alloc=1"
      "init_on_free=1"

      "intel_iommu=on,sm_on"
      "iommu.passthrough=0"

      "module.sig_enforce=1" # ?
      "proc_mem.force_override=ptrace"
      "randomize_kstack_offset=on"
      "rd.emergency=halt"
      "rd.shell=0"
      # "page_alloc.shuffle=1"
      # "slab_debug=FZ" perf?
      # "slab_nomerge" perf?
      "vdso32=0" # ?
      "vsyscall=none" # ?
    ];

    kernel.sysctl = {
      "kernel.kptr_restrict" = 2;
      "kernel.ftrace_enabled" = false;
      "kernel.sysrq" = 0;

      "net.ipv4.conf.*.send_redirects" = 0;
      "net.ipv4.conf.*.accept_redirects" = 0;
      "net.ipv6.conf.*.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;

      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = 1;

      "net.ipv4.icmp_echo_ignore_broadcasts" = true;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv6.icmp.echo_ignore_all" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;

      # https://github.com/secureblue/secureblue/commit/4e90e3beeeb0859ff2f6e2ec5bddf75167bc2243
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.conf.*.shared_media" = 0;
      "net.ipv4.conf.*.arp_filter" = 1;
      "net.ipv4.conf.*.arp_ignore" = 2;
      "net.ipv4.conf.all.drop_gratuitous_arp" = 1;
      "net.ipv4.conf.*.accept_source_route" = 0;
      "net.ipv6.conf.*.accept_source_route" = 0;
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 2;
      # "net.ipv6.conf.default.use_tempaddr" = 2;
      "net.core.bpf_jit_harden" = 2; # ?
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.perf_event_paranoid" = 3;
      "kernel.dmesg_restrict" = 1;
      "kernel.oops_limit" = 100;
      "kernel.warn_limit" = 100;
      "kernel.panic" = -1;
      "fs.binfmt_misc.status" = 0;
      "fs.suid_dumpable" = 0;
      "fs.protected_regular" = 2;
      "fs.protected_fifos" = 2;
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "dev.tty.ldisc_autoload" = 0;
      "vm.unprivileged_userfaultfd" = 0;
      "kernel.printk" = "3 3 3 3";
      "kernel.kexec_load_disabled" = 1;
      "kernel.core_pattern" = "/dev/null";
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      "kernel.randomize_va_space" = 2;
      "vm.mmap_min_addr" = 65536;

      "kernel.yama.ptrace_scope" = 3; # 3 breaks anticheat for it use 1
    };
  };

  systemd.settings.Manager.DumpCore = false;

  security = {
    protectKernelImage = true;
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

  programs.ssh = {
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-gcm@openssh.com"
      "aes128-ctr"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "sntrup761x25519-sha512@openssh.com"
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
    ];
    macs = [
      "hmac-sha2-256-etm@openssh.com"
      "hmac-sha2-512-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };
}
