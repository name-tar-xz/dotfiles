{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [
          "Symbols Nerd Font"
          "Iosevka Term"
        ];
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
              <test name="family">
                <string>Inter</string>
              </test>
              <edit name="fontfeatures" mode="assign_replace">
                <string>tnum</string>
                <string>frac</string>
                <string>ss04</string>
              </edit>
            </match>

            <match target="font">
              <test name="family">
                <string>Iosevka Term</string>
              </test>
              <edit name="fontfeatures" mode="append">
                <string>dlig</string>
              </edit>
            </match>
          </fontconfig>
        '';
    };
    packages = with pkgs; [
      nerd-fonts.symbols-only
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      inter
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
    ];
  };
}
