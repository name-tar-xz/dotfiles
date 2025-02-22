{ inputs, ... }:
{
  home.file = {
    ".mozilla/firefox/main/chrome/csshacks".source = inputs.csshacks;
    ".mozilla/firefox/main/chrome/includes".source = ./chrome/includes;
  };

  services.psd.enable = true;

  programs.firefox = {
    enable = true;

    policies = {
      ExtensionSettings =
        let
          # shortId: https://addons.mozilla.org/en-US/firefox/addon/${shortId}/ uuid: about:support
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        builtins.listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me")
          (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
          (extension "darkreader" "addon@darkreader.org")
          (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
          (extension "chameleon-ext" "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}")
        ];
    };

    profiles = {
      main = {
        extraConfig = ''
          ${builtins.readFile "${inputs.betterfox}/user.js"}
          ${builtins.readFile ./user.js}
        '';

        userChrome = builtins.readFile ./chrome/userChrome.css;
        userContent = builtins.readFile ./chrome/userContent.css;
      };
    };
  };
}
