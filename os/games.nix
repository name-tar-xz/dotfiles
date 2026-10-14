{ pkgs, ... }:
{
  system.replaceDependencies.replacements = with pkgs; [
    {
      oldDependency = networkmanager;
      newDependency = runCommand "networkmanager-${networkmanager.version}" { } "mkdir -p $out";
    }
    {
      oldDependency = modemmanager;
      newDependency = runCommand "modemmanager-${modemmanager.version}" { } "mkdir -p $out";
    }
  ];

  nixpkgs.overlays = [
    (_: prev: {
      dmemcg-booster = prev.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "dmemcg-booster";
        version = "0.1.3";
        cargoHash = "sha256-NHK4734Jvi4RJieGn0RjYU0PzQFqaE4exHG77dmukig=";

        src = prev.fetchFromGitLab {
          domain = "gitlab.steamos.cloud";
          owner = "holo";
          repo = "dmemcg-booster";
          tag = finalAttrs.version;
          hash = "sha256-JDT+JKxgaETinIHiP0Pqb7fPNrvcI6AQu90nmoA/YuI=";
        };

        env.PKG_CONFIG_PATH = "${prev.dbus.dev}/lib/pkgconfig";
        nativeBuildInputs = with prev; [ pkg-config ];

        installPhase = ''
          install -Dm755 target/x86_64-unknown-linux-gnu/release/dmemcg-booster "$out/bin/dmemcg-booster"

          # Set up systemd services
          install -Dm644 dmemcg-booster-system.service "$out/lib/systemd/system/dmemcg-booster-system.service"
          install -Dm644 dmemcg-booster-user.service "$out/lib/systemd/user/dmemcg-booster-user.service"
        '';
        fixupPhase = ''
          substituteInPlace $out/lib/systemd/system/dmemcg-booster-system.service \
            --replace-fail "/usr/bin/dmemcg-booster" "$out/bin/dmemcg-booster"
          substituteInPlace $out/lib/systemd/user/dmemcg-booster-user.service \
            --replace-fail "/usr/bin/dmemcg-booster" "$out/bin/dmemcg-booster"
        '';

        passthru.updateScript = prev.nix-update-script { };

        meta = {
          mainProgram = "dmemcg-booster";
          license = prev.lib.licenses.mit;
          platforms = prev.lib.platforms.linux;
          maintainers = with prev.lib.maintainers; [ ];
        };
      });
    })
  ];

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          LD_PRELOAD = ""; # Disable Steam Overlay
          PROTON_USE_WAYLAND = 1;
          # GE Only Config shorthand see https://github.com/GloriousEggroll/proton-ge-custom/blob/4bf56d6422677c1fc716f07c9630cc1e5c00941b/proton#L1856C1-L1892C68
          # CachyOS Only
          PROTON_USE_NTSYNC = 1;
        };
        # Maybe add nvidia-offload with extraProfile ?
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode = {
      enable = true;
      enableRenice = false;
      settings = {
        general = {
          renice = 20;
          ioprio = 0;
          softrealtime = "on";
        };
      };
    };
    gamescope = {
      enable = true;
      args = [
        "--expose-wayland"
        "--immediate-flips"
      ];
      capSysNice = false;
    };
  };
}
