{
  flake.homeModules.base = {
    programs.home-manager.enable = true;
    manual.manpages.enable = false;
    home.username = "pgattic";
    home.homeDirectory = "/home/pgattic";
    home.stateVersion = "25.11";
    # TODO: Migrate home-manager through 26.05
    # https://nix-community.github.io/home-manager/release-notes.xhtml#sec-release-26.05-state-version-changes
  };
}
