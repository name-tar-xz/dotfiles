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
        --sudo --no-reexec \
        {{ args }} \
        |& nom --json

[no-exit-message]
[private]
[script]
build-diff goal *args:
    before=$(readlink /run/current-system)
    just builder {{ goal }} {{ args }}
    lix diff "$before"

[default]
test *args: (build-diff "test" args)
switch *args: (build-diff "switch" args)
boot *args: (builder "boot" args)

clean:
    nix-collect-garbage --delete-older-than 3d

repl host=`hostname`:
    {{ rebuild }} repl --flake {{ flake }}#{{ host }}

[private]
flake action *args:
    nix flake {{ action }} --flake {{ flake }} --commit-lock-file --accept-flake-config {{ args }}

lock: (flake "lock")
update *inputs: (flake "update" inputs)

upgrade: update boot

verify *args:
    nix-store --verify {{ args }}

repair: (verify "--check-contents --repair")

[env("SOPS_AGE_KEY_FILE", "/var/lib/age.txt")]
[no-exit-message]
sops:
    sops secrets.yaml
