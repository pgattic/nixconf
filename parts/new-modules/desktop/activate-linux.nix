{
  flake.nixosModules.new-default = { config, lib, pkgs, ... }: let
    cfg = config.nixconf.desktop.activate-linux;
  in {
    options.nixconf.desktop.activate-linux = {
      enable = lib.mkEnableOption "the activate-linux watermark";
      package = lib.mkPackageOption pkgs "activate-linux" { };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra command-line arguments for activate-linux.";
      };
    };

    config = lib.mkIf (config.nixconf.desktop.enable && cfg.enable) {
      systemd.user.services.activate-linux = {
        description = "activate-linux watermark";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = lib.escapeShellArgs ([ (lib.getExe cfg.package) ] ++ cfg.extraArgs);
          Restart = "on-failure";
        };
      };
    };
  };
}
