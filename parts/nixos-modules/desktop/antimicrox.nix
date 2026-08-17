{
  flake.nixosModules.antimicrox = { lib, pkgs, ... }: {
    boot.kernelModules = [ "uinput" ];
    users.users.pgattic.extraGroups = lib.mkAfter [
      "input"
    ];
    hardware.uinput.enable = true;
    environment.systemPackages = [
      pkgs.antimicrox
    ];
  };
}
