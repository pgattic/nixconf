{ inputs, self, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;

    foot-base = wlib.evalModule ({
      inherit pkgs;
      imports = [ wlib.wrapperModules.foot ];
      env.FONTCONFIG_FILE = pkgs.makeFontsConf {
        fontDirectories = [ "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype" ];
      };
      filesToExclude = [ # Remove foot's client/server stuff
        "bin/footclient"
        "lib/systemd/user/*"
        "share/systemd/user/*"
        "share/applications/foot-server.desktop"
        "share/applications/footclient.desktop"
      ];
      settings = {
        main = {
          dpi-aware = "no";
          font = "JetBrainsMono Nerd Font:size=10";
          initial-color-theme = "dark";
          resize-delay-ms = 0;
          term = "xterm-256color";
        };
        cursor = {
          style = "beam";
          blink = true;
        };
        csd = {
          font = "Sans:size=10";
          color = "333333";
          button-color = "ffffff";
        };
        mouse-bindings.primary-paste = "none";
        colors-dark = {
          alpha = self.desktop.opacity;
          background = "1e1e1e"; # Was 1e1e1e
          foreground = "cccccc";
          regular0 = "000000";
          regular1 = "cd3131";
          regular2 = "0dbc79";
          regular3 = "e5e510";
          regular4 = "2472c8";
          regular5 = "bc3fbc";
          regular6 = "11a8cd";
          regular7 = "e5e5e5";
          bright0 = "666666";
          bright1 = "f14c4c";
          bright2 = "23d18b";
          bright3 = "f5f543";
          bright4 = "3b8eea";
          bright5 = "d670d6";
          bright6 = "29b8db";
          bright7 = "e5e5e5";
          blur = true;
        };
      };
    });

    foot = foot-base.config.apply ({ lib, ... }: {
      env.SHELL = lib.getExe self'.packages.nushell-env;
    });

    foot-rude = foot-base.config.apply ({ lib, ... }: {
      env.SHELL = lib.getExe self'.packages.nushell-env-rude;
    });
  in {
    packages = {
      foot-base = foot-base.config.wrapper;
      foot = foot.wrapper;
      foot-rude = foot-rude.wrapper;
    };
  };
}

