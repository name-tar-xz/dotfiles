{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.aa-alias-manager.nixosModules.default ];
  services.dbus.apparmor = "enabled";

  environment = {
    etc."apparmor/parser.conf".text = pkgs.lib.mkForce (
      ''
        ${if config.security.apparmor.enableCache then "write-cache" else "skip-cache"}
        cache-loc /var/cache/apparmor
        Optimize=compress-fast
        Include /etc/apparmor.d
      ''
      + pkgs.lib.concatMapStrings (p: "Include ${p}/etc/apparmor.d\n") config.security.apparmor.packages
    );
    systemPackages = with pkgs; [
      apparmor-d
      apparmor-parser
    ];
  };

  nixpkgs.overlays = [
    (_: prev: {
      apparmor-d = prev.buildGoModule {
        pname = "apparmor-d";
        version = "unstable";

        src = prev.fetchFromGitHub {
          rev = "8c5be78714bd457276748123e0263390904dbd2a";
          owner = "roddhjav";
          repo = "apparmor.d";
          hash = "sha256-rTmIu/ckXaWtMQ1ttMN7vP8LC2qMEMXR//j1kOluzW8=";
        };

        vendorHash = null;

        doCheck = false;
        dontCheckForBrokenSymlinks = true;

        patches = [ ./prebuild.patch ];

        subPackages = [
          "cmd/prebuild"
          "cmd/aa-log"
        ];

        passthru.updateScript = prev.unstableGitUpdater { };

        postInstall = ''
          mkdir -p $out/etc

          DISTRIBUTION=arch $out/bin/prebuild --complain # fixme: replace with nixos support once available

          mv .build/apparmor.d $out/etc
          rm $out/bin/prebuild
        '';

        meta = {
          description = "Full set of AppArmor profiles (~ 1500 profiles) ";
          homepage = "https://github.com/roddhjav/apparmor.d";
          mainProgram = "aa-log";
        };
      };
    })
  ];

  security = {
    auditd.enable = false;
    apparmor = {
      enable = true;
      enableCache = true;
      packages = [ pkgs.apparmor-d ];
      policies = builtins.mapAttrs (name: state: {
        inherit state;
        path = "${pkgs.apparmor-d}/etc/apparmor.d/${name}";
      }) (import ./.progs.nix);
      aa-alias-manager.patterns = [
        {
          disallowed_strings = [
            "!"
            ","
          ];
          individual = true;
          name = "bin";
          only_exe = true;
          only_include = [ ];
          store_suffixes = [
            "bin"
            "libexec"
            "sbin"
            "usr/bin"
            "usr/sbin"
          ];
          target = "/bin";
        }
      ];
    };
  };

  specialisation = pkgs.lib.mkIf config.security.apparmor.enable {
    no-apparmor.configuration.security.apparmor.enable = pkgs.lib.mkForce false;
  };
}
