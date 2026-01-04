{ pkgs, lib, ... }:
{
  programs.lf = {
    enable = true;
    previewer.source = pkgs.writeShellScript "pv.sh" ''
      file=$1
      w=$2
      h=$3
      x=$4
      y=$5

      if [[ "$(${lib.getExe pkgs.file} -Lb --mime-type "$file")" =~ ^image ]]; then
        ${lib.getExe' pkgs.kitty "kitten"} icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
      fi

      ${lib.getExe pkgs.bat} --color=always "$file"
    '';
    settings = {
      icons = true;
      hidden = true;
      number = true;
      relativenumber = true;
      info = "size";
      cursorpreviewfmt = "";
      scrolloff = 999;
      cleaner = "${pkgs.writeShellScript "cl.sh" "${lib.getExe' pkgs.kitty "kitten"} icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty"}";
    };
  };
}
