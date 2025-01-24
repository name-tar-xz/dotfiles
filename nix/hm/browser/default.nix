{ pkgs, inputs, ... }:
{
  imports = [ inputs.nur.modules.homeManager.default ];

  home.file = {
    ".librewolf/main/chrome/csshacks".source = inputs.csshacks;
    ".librewolf/main/chrome/includes".source = ./chrome/includes;
  };

  services.psd.enable = true;

  programs.librewolf = {
    enable = true;
    profiles = {
      main = {
        extraConfig = ''
          ${builtins.readFile "${inputs.betterfox}/user.js"}
          ${builtins.readFile ./user.js}
        '';

        userChrome = builtins.readFile ./chrome/userChrome.css;
        userContent = builtins.readFile ./chrome/userContent.css;

        extensions = with inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons; [
          ublock-origin
          libredirect
          proton-pass
          tree-style-tab
          darkreader
          tridactyl
          nighttab

          redirector
          violentmonkey
          user-agent-string-switcher
        ];
      };
    };
  };
}
