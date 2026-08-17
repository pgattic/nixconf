{
  flake.homeModules.obsidian = {
    programs.obsidian = {
      enable = true;
      defaultSettings.app = {
        vimMode = true;
        showInlineTitle = false;
      };
    };
  };
}
