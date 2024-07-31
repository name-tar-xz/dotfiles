#!/bin/sh
#install package from repo
inrp() {
  pacman -S "$(pacman -Slq "$1" | fzf --preview "pacman -Si $1/{}")"
}
inlcl() {
  pacman -Qq | fzf --preview "pacman -Qi {}"
}
pkgse() {
  pacman -S "$(pacman -Ssq "$1" | fzf --preview "pacman -Si {}")"
}

extract() {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
  else
    for n in "$@"; do
      if [ -f "$n" ]; then
        case "${n%,}" in
        *.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
          tar xvf "$n"
          ;;
        *.lzma) unlzma ./"$n" ;;
        *.bz2) bunzip2 ./"$n" ;;
        *.cbr | *.rar) unrar x -ad ./"$n" || unrar-free x -ad ./"$n" ;;
        *.gz) gunzip ./"$n" ;;
        *.cbz | *.epub | *.zip) unzip ./"$n" ;;
        *.z) uncompress ./"$n" ;;
        *.7z | *.arj | *.cab | *.cb7 | *.chm | *.deb | *.dmg | *.iso | *.lzh | *.msi | *.pkg | *.rpm | *.udf | *.wim | *.xar)
          7z x ./"$n"
          ;;
        *.xz) unxz ./"$n" ;;
        *.exe) cabextract ./"$n" ;;
        *.cpio) cpio -id <./"$n" ;;
        *.cba | *.ace) unace x ./"$n" ;;
        *)
          echo "extract: '$n' - unknown archive method"
          return 1
          ;;
        esac
      else
        echo "'$n' - file does not exist"
        return 1
      fi
    done
  fi
}

help() {
  "$@" --help 2>&1 | bat --plain --language=help --color=always
}

lfcd() {
  # `command` is needed in case `lfcd` is aliased to `lf`
  cd "$(command lf -print-last-dir "$@")" || return
}

rangercd() {
  tmp="$(mktemp)"
  ranger --choosedir="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    /bin/rm -f "$tmp"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && command cd "$dir" || return
  fi
}

arduino_run() {
  arduino-cli compile -b "$1" -p "$2" "$3"
  arduino-cli upload -b "$1" -p "$2" "$3"
  # arduino-cli monitor -b "$1" -p "$2 -c baudrate=$4"
}

respawn() {
  pkill "$1"
  $1 &
  disown
}

rg() {
  command rg --json "$@" | delta --paging never
}
