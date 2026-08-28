{ config, ... }: {
  flake.homeModules.desktop-default = {
    imports = [
      config.flake.homeModules.desktop-base
    ];
  };
}
