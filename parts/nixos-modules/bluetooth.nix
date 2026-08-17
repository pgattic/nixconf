{
  flake.nixosModules.bluetooth = { lib, ... }: {
    hardware.bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
      settings.General.Experimental = true;
    };
  };
}
