{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "IosevkaTerm Nerd Font Mono" ];
      };
      includeUserConf = false;
      antialias = true;
      subpixel.rgba = "none";
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      localConf = # xml
        ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <match target="font">
              <test name="fontformat" compare="not_eq">
                <string />
              </test>
              <test name="family">
                <string>Inter</string>
              </test>
              <edit name="fontfeatures" mode="assign_replace">
                <string>tnum</string>
              </edit>
              <edit name="fontfeatures" mode="append">
                <string>ss04</string>
              </edit>
            </match>
          </fontconfig>
        '';
    };
    packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.iosevka-term
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      inter
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
    ];
  };
}
