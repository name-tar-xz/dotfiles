{ ... }:
{
  boot.kernel.sysctl = {
    # CachyOS
    "vm.vfs_cache_pressure" = 50;
    "vm.page-cluster" = 0;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.max_map_count" = 2147483642;
    "kernel.nmi_watchdog" = 0;
    "kernel.unprivileged_userns_clone" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.kptr_restrict" = 2;
    "kernel.kexec_load_disabled" = 1;
    "net.core.netdev_max_backlog" = 4096;
    "net.ipv4.tcp_ecn" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_rfc1337" = 1;
    "fs.file-max" = 2097152;
    "kernel.core_pattern" = "/dev/null";
    "kernel.split_lock_mitigate" = 0;
    "dev.hpet.max-user-freq" = 3072;
    # Clear Linux
    "vm.dirty_ratio" = 50;
    "vm.dirty_background_ratio" = 20;
    "vm.extfrag_threshold" = 100;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.busy_poll" = 50;
    "net.core.busy_read" = 50;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Gaming
    "vm.compaction_proactiveness" = 0;
    "vm.page_lock_unfairness" = 1;

    "net.core.default_qdisc" = "cake";
  };
}
