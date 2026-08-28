{
  flake.homeModules.desktop = { pkgs, ... }: {
    # Disable baloo indexer (install ripgrep-all to get search functionality)
    home.file.".config/baloofilerc".text = ''
      [Basic Settings]
      Indexing-Enabled=false
    '';

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/vnd.avi" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        # "text/html" = "librewolf.desktop";
        # "x-scheme-handler/http" = "librewolf.desktop";
        # "x-scheme-handler/https" = "librewolf.desktop";
      };
    };
  };
}
