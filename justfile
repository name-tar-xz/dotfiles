set quiet := true

alias up := update
alias sw := switch

export NH_FLAKE := justfile_directory()

default:
  nh os test --accept-flake-config

switch:
  nh os switch --accept-flake-config

boot:
  nh os boot --accept-flake-config

clean:
  nh clean all

repl:
  nh os repl

update:
  nix flake update --flake $NH_FLAKE --commit-lock-file --accept-flake-config
  nh os boot --accept-flake-config

export SOPS_AGE_KEY_FILE := "/var/lib/age.txt"

sops:
  sops secrets.yaml
