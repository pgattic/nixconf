{ inputs, self, ... }: {
  perSystem = { pkgs, self', ... }: let
    assets = ../../assets;
    wlib = inputs.nix-wrapper-modules.lib;
    tomlFormat = pkgs.formats.toml { };
    noctalia-package = pkgs.noctalia;
    # noctalia-package = pkgs.replaceDependency {
    #   drv = pkgs.noctalia;
    #   oldDependency = pkgs.git;
    #   newDependency = pkgs.gitMinimal;
    # };
    default_config = {
      bar.default = {
        capsule_group = [
          { id = "monitor"; opacity = 0; members = [ "cpumon" "memmon" "tempmon" ]; }
        ];
        start = [ "workspaces" "group:monitor" "media" ];
        center = [ "active_window" ];
        end = [ "tray" "clipboard" "brightness" "volume" "bluetooth" "network" "battery" "notifications" "clock" "control-center" ];
        background_opacity = self.lib.desktop.opacity;
        margin_edge = 0;
        margin_ends = 0;
        padding = 6;
        radius = 0;
        shadow = false;
        thickness = 24;
        widget_spacing = 12;
      };
      audio.enable_overdrive = true;
      control_center.sidebar_section = "none";
      desktop_widgets.enabled = false;
      location.address = "Provo, United States";
      nightlight.enabled = true;
      osd = {
        background_opacity = self.lib.desktop.opacity;
        position = "bottom_center";
        position_vertical = "center_right";
      };
      shell = {
        avatar_path = "${assets}/profile.jpg";
        panel.open_near_click_control_center = true;
        screen_time_enabled = true;
        launcher.fetch_exchange_rates = false;
      };
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "MyGHDark";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      wallpaper = {
        directory = "${assets}/wallpapers";
        default.path = "${assets}/wallpapers/wedding_temple.jpg";
        transition = [ "honeycomb" "stripes" ];
      };
      weather.unit = "imperial";
      widget = let
        sysmon_stat = stat: { inherit stat; type = "sysmon"; show_value = false; };
      in {
        # Default Widget Customization
        active_window.max_length = 800;
        battery = {
          display_mode = "graphic";
          show_label = false;
        };
        brightness.show_label = false;
        clock.format = "{:%a %b %d %-I:%M %p}";
        control-center.custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        media.hide_when_no_media = true;
        network.show_label = false;
        volume.show_label = false;
        workspaces = {
          show_labels = false;
          pill_scale = 0.75;
        };

        # Custom Widgets
        cpumon = sysmon_stat "cpu_usage";
        memmon = sysmon_stat "ram_used";
        tempmon = sysmon_stat "cpu_temp";
      };
    };
    mkNoctalia = cfg: wlib.wrapPackage ({ config, ... }: {
      inherit pkgs;
      package = noctalia-package;
      env.NOCTALIA_CONFIG_HOME = "${builtins.placeholder "out"}/config";
      constructFiles = {
        github-dark-palette = {
          relPath = "config/noctalia/palettes/MyGHDark.json";
          content = builtins.toJSON {
            dark = {
              mPrimary = "#58a6ff";
              mOnPrimary = "#010409";
              mSecondary = "#add3ff"; # was "#bc8cff"
              mOnSecondary = "#010409";
              mTertiary = "#add3ff"; # was "#bc8cff"
              mOnTertiary = "#010409";
              mError = "#f85149";
              mOnError = "#010409";
              mSurface = "#010409";
              mOnSurface = "#c9d1d9";
              mSurfaceVariant = "#161b22";
              mOnSurfaceVariant = "#8b949e";
              mOutline = "#30363d";
              mShadow = "#010409";
              mHover = "#21262d";
              mOnHover = "#c9d1d9";
              terminal = {};
            };
          };
        };
        noctalia-config = {
          relPath = "config/noctalia/noctalia-config.toml";
          content = builtins.readFile (tomlFormat.generate "noctalia-config.toml" cfg);
        };
      };
    });

    touch_config = default_config // {
      shell.launcher.app_grid = true;
      widget.osk = {
        glyph = "keyboard";
        tooltip = "Open/Close On-Screen Keyboard";
        type = "custom_button";
        actions.left = "exec ${pkgs.procps}/bin/pgrep wvkbd-deskintl >/dev/null && ${pkgs.procps}/bin/pkill wvkbd-deskintl || exec ${self'.packages.wvkbd-deskintl}/bin/wvkbd-deskintl -L 412";

      };
      bar.default = {
        thickness = 28;
        start = [ "workspaces" "group:monitor" "launcher" "osk" "media" ];
      };
    };

    mobile_config = touch_config // {
      shell.panel.launcher_position = "top_center";
      widget.osk.actions.left = "exec ${pkgs.procps}/bin/pgrep wvkbd-mobintl >/dev/null && ${pkgs.procps}/bin/pkill wvkbd-mobintl || exec ${pkgs.wvkbd}/bin/wvkbd-mobintl -H 400 -L 250 -R 16 -o | ${pkgs.clickclack}/bin/clickclack -V -E /dev/input/by-path/*haptics*";

      bar.default = {
        background_opacity = 1.0;
        padding = 16;
        start = [ "launcher" "workspaces" "tray" ];
        center = []; # OnePlus 6 has a notch
        end = [ "osk" "battery" "clock" "control-center" ];
      };
      osd.orientation = "vertical";
      shell.session.grid = true;
    };
  in {
    packages = {
      noctalia5 = mkNoctalia default_config;
      noctalia5-touch = mkNoctalia touch_config;
      noctalia5-mobile = mkNoctalia mobile_config;
    };
  };
}
