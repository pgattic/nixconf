{
  flake.nixosModules.networking = { lib, ... }: {
    networking.networkmanager.enable = lib.mkDefault true;
    users.users.pgattic.extraGroups = lib.mkAfter [ "networkmanager" ];
  };
}
