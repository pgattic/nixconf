{ self, ... }: {
  flake.nixosModules.nextcloud = { pkgs, ... }: let
    cfg = self.lib.server;
  in {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud34;
      hostName = "cloud.${cfg.domain}";
      https = true;

      home = "${cfg.paths.store}/nextcloud";
      maxUploadSize = "50G";

      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminuser = "pgattic";
        adminpassFile = "${cfg.paths.secrets}/nextcloud-admin-pass";
      };

      settings = {
        default_phone_region = "US";
        log_type = "systemd";
      };
    };

    systemd.services.nextcloud-setup = {
      after = [ "zfs-mount.service" ];
      requires = [ "zfs-mount.service" ];
    };
    systemd.services.postgresql = {
      after = [ "zfs-mount.service" ];
      requires = [ "zfs-mount.service" ];
    };

    services.nginx.virtualHosts."cloud.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
