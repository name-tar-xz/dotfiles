set lazy
set quiet

alias up := upgrade
alias sw := switch

rebuild := "nixos-rebuild"
flake := justfile_directory()

[no-exit-message]
[private]
builder goal *args:
    {{ rebuild }} {{ goal }} \
        --flake {{ flake }} \
        --accept-flake-config \
        --log-format internal-json \
        --elevate=run0 --no-reexec \
        --diff {{ args }} \
        |& nom --json

[default]
test *args: (builder "test" args)
switch *args: (builder "switch" args)
boot *args: (builder "boot" args)

rb *args: (boot args)
    systemctl reboot

clean:
    nix-collect-garbage --delete-older-than 3d

repl host=`hostname`:
    {{ rebuild }} repl --flake {{ flake }}#{{ host }}

[private]
flake action *args:
    nix flake {{ action }} --commit-lock-file --accept-flake-config {{ args }}

lock: (flake "lock")
update *inputs: (flake "update" inputs)

upgrade: update boot

verify *args:
    nix-store --verify {{ args }}

repair: (verify "--check-contents --repair")

iso:
    nom build .#nixosConfigurations.iso.config.system.build.isoImage --accept-flake-config

[env("SOPS_AGE_KEY_FILE", "/var/lib/age.txt")]
[no-exit-message]
sops:
    sops secrets.yaml
