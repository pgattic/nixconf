{ config, ... }: {
  flake.nixosModules.desktop-default = {
    imports = [
      config.flake.nixosModules.desktop-base
      config.flake.nixosModules.bluetooth
    ];
  };
}
