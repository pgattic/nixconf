{ config, ... }: {
  flake.homeModules.default = {
    imports = [
      config.flake.homeModules.base
    ];
  };
}
