let port = 2283; in {
  flake.nixosModules.immich = { config, ... }: let cfg = config.my.server; in {
    services.immich = {
      inherit port;
      enable = true;
      host = "127.0.0.1";
      accelerationDevices = null;
      settings = {
        newVersionCheck.enabled = false;
      };
      mediaLocation = "/tank/store/immich";
    };
    services.postgresql = {
      dataDir = "/tank/appdata/postgresql/${config.services.postgresql.package.psqlSchema}";
    };
    systemd.services.immich-server.after = [ "zfs-mount.service" ];
    systemd.services.immich-server.requires = [ "zfs-mount.service" ];
    systemd.services.postgresql.after = [ "zfs-mount.service" ];
    systemd.services.postgresql.requires = [ "zfs-mount.service" ];

    services.nginx.virtualHosts."photos.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };
}

