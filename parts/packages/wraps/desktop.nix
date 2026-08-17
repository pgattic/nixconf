{
  perSystem = { pkgs, self', ... }: {
    packages.desktop = pkgs.symlinkJoin {
      name = "desktop";
      paths = [
        self'.packages.sioyek
        pkgs.imv
        pkgs.mpv-unwrapped
        pkgs.kdePackages.ark
          # pkgs.unrar # Nonfree package # TODO: get a system to include this
        pkgs.kdePackages.dolphin
      ];
      meta.description = "Meta-package providing commonly used graphical apps";
    };
  };
}
