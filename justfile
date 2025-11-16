set quiet := true

alias up := update
alias sw := switch

export NH_FLAKE := justfile_directory()

default:
  nh os test

switch:
  nh os switch

boot:
  nh os boot

clean:
  nh clean all

repl:
  nh os repl

update:
  nix flake update --flake /home/tarxz/.config/nixos --commit-lock-file
  nh os boot
