{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        size.binaryPrefix = "si";
        hideCursor = true;
        percent = {
          type = 3;
        };
        separator = "  ➜ ";
      };
      modules = [
        "title"
        "separator"
        {
          key = "󱄅";
          keyColor = "cyan";
          type = "os";
        }
        {
          key = "󰻀";
          keyColor = "light_yellow";
          type = "kernel";
        }
        {
          key = "󰥔";
          keyColor = "blue";
          type = "uptime";
        }
        {
          key = "󰏖";
          keyColor = "red";
          type = "packages";
        }
        "break"
        {
          key = "";
          keyColor = "magenta";
          type = "shell";
        }
        {
          key = "";
          keyColor = "yellow";
          type = "terminal";
        }
        {
          key = "";
          keyColor = "light_green";
          type = "wm";
        }
        "break"
        {
          key = "󰻠";
          keyColor = "light_cyan";
          type = "cpu";
        }
        {
          key = "󰘚";
          keyColor = "light_red";
          type = "gpu";
        }
        {
          key = "󰍛";
          keyColor = "light_magenta";
          type = "memory";
        }
        {
          key = "󰋊";
          keyColor = "light_blue";
          type = "disk";
        }
        {
          key = "";
          keyColor = "green";
          type = "battery";
        }
        "break"
        {
          type = "custom";
          format = "{#30}  {#31}  {#32}  {#33}  {#34}  {#35}  {#36}  {#37}    {#97}  {#96}  {#95}  {#94}  {#93}  {#92}  {#91}  {#90} ";
        }
      ];
    };
  };
}
