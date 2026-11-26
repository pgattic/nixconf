{
  flake.nixosModules.new-default = { config, lib, pkgs, ... }: {
    options.nixconf.desktop.bluetooth.enable = lib.mkEnableOption "my bluetooth options";

    config = lib.mkIf config.nixconf.desktop.bluetooth.enable {
      hardware.bluetooth = {
        enable = lib.mkDefault true;
        powerOnBoot = lib.mkDefault true;
        settings.General.Experimental = true;
      };
    };
  };
}
