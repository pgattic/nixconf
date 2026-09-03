{ self, ... }: let port = 8096; in {
  flake.nixosModules.jellyfin = { config, pkgs, ... }: {
    # Help transcode movies faster
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = [ pkgs.intel-media-driver ]; # for newer Intel

    services.jellyfin = {
      enable = true;
      dataDir = "/tank/appdata/jellyfin";
    };
    users.users.jellyfin.extraGroups = [ "media" ];

    systemd.services.jellyfin.after = [ "zfs-mount.service" ];
    systemd.services.jellyfin.requires = [ "zfs-mount.service" ];

    services.nginx.virtualHosts."cinema.${self.lib.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        # Jellyfin-friendly extras (help streaming, seeks, large payloads)
        extraConfig = ''
          proxy_buffering off;
          client_max_body_size 0;
          proxy_read_timeout 3600s;
          proxy_send_timeout 3600s;
          send_timeout 3600s;
        '';
      };
    };
  };
}
