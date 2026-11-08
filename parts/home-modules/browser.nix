{
  flake.homeModules.browser = { pkgs, ... }: let
    defaultOptions = {
      extensions.force = true;
      bookmarks.force = true;
      bookmarks.settings = [
        { "name" = "NixOS Search"; url = "https://search.nixos.org"; tags = ["nixos" "search"]; }
        { "name" = "pgattic.dev"; url = "https://pgattic.dev"; }
      ];
      search.force = true;
      search.default = "google";
      search.engines = {
        google = {
          name = "Google";
          urls = [{
            template = "https://www.google.com/search";
            params = [{ name = "q"; value = "{searchTerms}"; }];
          }];
          icon = "https://www.google.com/favicon.ico";
          definedAliases = [ "@g" ];
        };
        wikipedia = {
          name = "Wikipedia";
          urls = [{
            template = "https://en.wikipedia.org/w/index.php";
            params = [
              { name = "search"; value = "{searchTerms}"; }
            ];
          }];
          icon = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
          definedAliases = [ "@w" ];
        };
        nix-packages = {
          name = "NixOS Packages";
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "channel"; value = "unstable"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "https://search.nixos.org/favicon-96x96.png";
          definedAliases = [ "@nix" ];
        };
      };
      settings = {
        # Librewolf-specific stuff
        "privacy.clearOnShutdown.cache" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown_v2.cache" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        # Unfortunately required for muh dark mode to work (and webGL)
        "privacy.resistFingerprinting" = false;
        "network.cookie.lifetimePolicy" = 0;
        "webgl.disabled" = false;
        "webgl.force-enabled" = true;

        # Firefox stuff
        "findbar.highlightAll" = true;
        "browser.profiles.enabled" = true;
        "browser.gesture.swipe.left" = "cmd_scrollLeft";
        "browser.gesture.swipe.right" = "cmd_scrollRight";
        "browser.cache.memory.capacity" = 1048576 * 3; # 3 Gigabytes
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable UserChrome.css
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "simple-tab-groups@drive4ik";
        "browser.toolbars.bookmarks.visibility" = "never"; # "always", "never", "newtab"
        "browser.tabs.inTitlebar" = 0; # Hide client-side decorations
        "browser.startup.page" = 3; # Reopen last session on start
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [ ];
            nav-bar = [
              "sidebar-button"
              "back-button"
              "forward-button"
              "stop-reload-button"
              "customizableui-special-spring1"
              "vertical-spacer"
              "urlbar-container"
              "customizableui-special-spring2"
              "downloads-button"
              "fxa-toolbar-menu-button"
              # "unified-extensions-button"
              "ublock0_raymondhill_net-browser-action"
              # "alltabs-button"
            ];
            toolbar-menubar = [
              "menubar-items"
            ];
            TabsToolbar = [];
            vertical-tabs = [
              "tabbrowser-tabs"
            ];
            PersonalToolbar = [
              "personal-bookmarks"
            ];
          };
          seen = [
            "developer-button"
            "screenshot-button"
            "ublock0_raymondhill_net-browser-action"
            "firefoxcolor_mozilla_com-browser-action"
          ];
          dirtyAreaCache = [
            "nav-bar"
            "vertical-tabs"
            "unified-extensions-area"
            "TabsToolbar"
            "toolbar-menubar"
            "PersonalToolbar"
          ];
          currentVersion = 23;
          newElementCount = 2;
        };
      };
    };
  in {
    programs.librewolf = {
      enable = true;
      profiles.pgattic = defaultOptions // {
        id = 0;
        isDefault = false;
      };
      profiles.work = defaultOptions // {
        id = 1;
        isDefault = true;
      };
    };
  };
}
