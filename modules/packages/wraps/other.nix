{ inputs, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
  in {
    packages = {
      btop = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.btop ];
        settings = {
          theme_background = false;
          vim_keys = true;
          proc_gradient = false;
          proc_filter_kernel = true;
        };
      };
      fastfetch = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.fastfetch ];
        settings = {
          logo = "NixOS";
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
          modules = [
            "title"
            "separator"
            "os" "host" "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "de" "wm"
            "terminal" "terminalfont"
            "cpu" "gpu" "memory" "swap" "disk"
            "localip"
            "battery"
            "poweradapter"
            "break"
            "colors"
          ];
        };
      };
      git = wlib.wrapPackage ({ config, ... }: {
        inherit pkgs;
        package = pkgs.gitMinimal;
        constructFiles.gitConfig = {
          relPath = "gitconfig";
          content = ''
            [color]
              ui = "auto"
            [init]
              defaultBranch = "master"
            [user]
              email = "pgattic@gmail.com"
              name = "pgattic"
          '';
        };
        env.GIT_CONFIG_GLOBAL = config.constructFiles.gitConfig.path;
      });
      helix = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.helix ];
        themes.darkplus-transparent = {
          inherits = "dark_plus";
          "ui.background" = {};
        };
        settings = {
          theme = "darkplus-transparent";
          editor = {
            middle-click-paste = false;
            bufferline = "multiple";
            color-modes = true;
            cursorline = true;
            end-of-line-diagnostics = "hint"; # works in-tandem with `editor.inline-diagnostics`
            statusline = {
              left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" "version-control"]; # Add version-control
            };
            lsp.display-inlay-hints = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            indent-guides = {
              render = true;
              character = "▏";
            };
            inline-diagnostics.cursor-line = "warning"; # warnings/errors inline on the cursorline
            # gutters.layout = ["diagnostics" "spacer" "line-numbers" "spacer" "diff"];
            # soft-wrap = {
            #   enable = true;
            #   max-wrap = 25; # increase value to reduce forced mid-word wrapping
            #   max-indent-retain = 0;
            #   wrap-indicator = "";  # set wrap-indicator to "" to hide it
            # };
          };
        };
      };
      jujutsu = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.jujutsu ];
        settings = {
          user.name = "pgattic";
          user.email = "pgattic@gmail.com";
          ui = {
            default-command = [ "log" "--reversed" ];
            paginate = "never";
          };
        };
      };
      luanti-client = wlib.wrapPackage {
        inherit pkgs;
        package = pkgs.luanti-client;
        env.SDL_VIDEODRIVER = "wayland,x11"; # Prefer wayland first, fall back to xorg
      };
      nh = wlib.wrapPackage {
        inherit pkgs;
        package = pkgs.nh;
        env.NH_FLAKE = "/home/pgattic/dotfiles";
      };
      sioyek = wlib.wrapPackage {
        inherit pkgs;
        package = pkgs.sioyek;
        env.XDG_CONFIG_HOME = "${builtins.placeholder "out"}/config";
        constructFiles.sioyekPrefs = {
          relPath = "config/sioyek/prefs_user.config";
          content = ''
            background_color #161b22
            custom_background_color #161b22
            custom_text_color #c9d1d9
            highlight_color_a #bb8009
            highlight_color_b #2ea043
            highlight_color_c #388bfd
            highlight_color_d #f85149
            highlight_color_e #a371f7
            highlight_color_f #db6d28
            highlight_color_g #bb8009
            link_highlight_color #388bfd
            search_highlight_color #bb8009
            should_highlight_unselected_search 1
            startup_commands toggle_custom_color
            status_bar_color #30363d
            status_bar_text_color #c9d1d9
            super_fast_search 0
            synctex_highlight_color #2ea043
            text_highlight_color #bb8009
            ui_background_color #30363d
            ui_selected_background_color #484f58
            ui_selected_text_color #c9d1d9
            ui_text_color #c9d1d9
            # visual_mark_color #484f58
          '';
        };
      };
      zed-editor = wlib.wrapPackage ({ lib, ... }: {
        inherit pkgs;
        package = pkgs.zed-editor;
        # Some libs that Codex depends on
        extraPackages = [
          pkgs.libcap
          pkgs.libz
        ];
        env.SHELL = lib.getExe (self'.packages.nushell.apply {
          extraPackages = [ pkgs.file ];
        }).wrapper;
        constructFiles.settings = {
          relPath = "config/settings.json";
          content = builtins.toJSON { # run "zed: open default settings" to see all options
            telemetry = {
              diagnostics = false;
              metrics = false;
            };
            vim_mode = true;
            window_decorations = "server";
            buffer_line_height = "standard";
            auto_update = false;
            tab_size = 2;
            inlay_hints.enabled = true;
            show_edit_predictions = false;
          };
        };
        # Zed checks for a writeable config file, so we put it in $XDG_RUNTIME_DIR
        runShell = [
          ''
            ZED_CFG_HOME="$XDG_RUNTIME_DIR/zed-wrapped-$$"
            mkdir -p "$ZED_CFG_HOME/zed"
            cp -r ${builtins.placeholder "out"}/config/* "$ZED_CFG_HOME/zed"
            export XDG_CONFIG_HOME="$ZED_CFG_HOME"
          ''
        ];
      });
      zellij = wlib.wrapPackage ({ config, ... }: {
        inherit pkgs;
        package = pkgs.zellij;
        constructFiles.zellijConfig = {
          relPath = "config.kdl";
          content = ''
            show_startup_tips false
          '';
        };
        flags."--config" = config.constructFiles.zellijConfig.path;
      });
    };
  };
}

