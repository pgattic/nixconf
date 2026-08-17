{ inputs, self, ... }: let port = 3251; in {
  flake.nixosModules.barp = {
    imports = [
      inputs.barp.nixosModules.default
    ];

    services.barp = {
      inherit port;
      enable = true;
      romsPath = "/tank/media/roms";
      savesPath = "/tank/store/barp";
      users = {
        pgattic.passwordHashFile = "/tank/secrets/barp-hashes/pgattic";
        guest.passwordHashFile = "/tank/secrets/barp-hashes/guest";
      };
    };

    systemd.services.barp.after = [ "zfs-mount.service" ];
    systemd.services.barp.requires = [ "zfs-mount.service" ];

    systemd.tmpfiles.rules = [
      "d /tank/store/barp 0750 barp barp -"
    ];

    services.nginx.virtualHosts."roms.${self.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect http:// $scheme://;
          client_max_body_size 30m;
        '';
      };
    };
  };
}
