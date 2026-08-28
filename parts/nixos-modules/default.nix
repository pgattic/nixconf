{ config, ... }: {
  flake.nixosModules.default = {
    imports = [
      config.flake.nixosModules.debloat
      config.flake.nixosModules.base
      config.flake.nixosModules.networking
      config.flake.nixosModules.user
    ];
  };
}
