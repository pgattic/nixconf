{ inputs, self, ... }: {
  perSystem = { pkgs, self', ... }: let
    assets = ../../../assets;
    wlib = inputs.nix-wrapper-modules.lib;
    tomlFormat = pkgs.formats.toml { };
    noctalia5-package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    default_config = {
      bar = {
        default = {
          background_opacity = self.desktop.opacity;
          start = [ "workspaces" "cpumon" "memmon" "tempmon" "media" ];
          center = [ "active_window" ];
          end = [ "tray" "clipboard" "brightness" "volume" "bluetooth" "network" "battery" "notifications" "clock" "control-center" ];
          margin_edge = 0;
          margin_ends = 0;
          padding = 6;
          radius = 0;
          shadow = false;
          thickness = 24;
          widget_spacing = 12;
        };
      };
      audio.enable_overdrive = true;
      control_center.sidebar_section = "none";
      desktop_widgets.enabled = false;
      location.address = "Provo, United States";
      nightlight.enabled = true;
      osd = {
        background_opacity = self.desktop.opacity;
        position = "bottom_center";
      };
      shell = {
        avatar_path = "${assets}/profile.jpg";
        panel.open_near_click_control_center = true;
        screen_time_enabled = true;
      };
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "MyGHDark";
      };
      wallpaper = {
        directory = "${assets}/wallpapers";
        default.path = "${assets}/wallpapers/wedding_temple.jpg";
        transition = [ "honeycomb" "stripes" ];
      };
      weather.unit = "imperial";
      widget = let
        sysmon_stat = stat: { inherit stat; type = "sysmon"; show_label = false; };
      in {
        # Default Widget Customization
        active_window.max_length = 800;
        battery = {
          display_mode = "graphic";
          show_label = false;
        };
        brightness.show_label = false;
        clock.format = "{:%a %b %d %l:%M %p}";
        control-center.custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        media.hide_when_no_media = true;
        network.show_label = false;
        volume.show_label = false;
        workspaces = {
          # labels_only_when_occupied = true;
          display = "none"; # No labels
          pill_scale = 0.75;
        };

        # Custom Widgets
        cpumon = sysmon_stat "cpu_usage";
        memmon = sysmon_stat "ram_used";
        tempmon = sysmon_stat "cpu_temp";
      };
    };
    mkNoctalia5 = cfg: wlib.wrapPackage ({ config, ... }: {
      inherit pkgs;
      package = noctalia5-package;
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
  in {
    packages = {
      noctalia5 = mkNoctalia5 default_config;
    };
  };
}
