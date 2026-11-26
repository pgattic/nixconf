{
  flake.nixosModules.new-default = { config, lib, pkgs, ... }: {
    config = lib.mkIf config.nixconf.enable {
      users.users.${config.nixconf.user} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "input" ];
        description = lib.mkDefault "Preston Corless";
      };
    };
  };
}
