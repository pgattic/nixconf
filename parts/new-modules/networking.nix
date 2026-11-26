{
  flake.nixosModules.new-default = { config, lib, pkgs, ... }: {
    options.nixconf = {
      networking.enable = lib.mkOption {
        type = lib.types.bool;
        default = config.nixconf.enable;
        description = "Whether to enable my networking options";
      };
    };

    config = lib.mkIf config.nixconf.networking.enable {
      networking.networkmanager.enable = lib.mkDefault true;
      users.users.${config.nixconf.user}.extraGroups = lib.mkAfter [ "networkmanager" ];
    };
  };
}
