let port = 2285; in {
  flake.nixosModules.forgejo = { config, ... }: let cfg = config.my.server; in {
    services.forgejo = {
      enable = true;
      stateDir = "/tank/store/forgejo";
      settings = {
        server = {
          DOMAIN = "git.${cfg.domain}";
          ROOT_URL = "https://git.${cfg.domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = port;
        };
        service.DISABLE_REGISTRATION = true;
        DEFAULT.APP_NAME = "Corless Family Git Forge";
        repository.DEFAULT_BRANCH = "master";
      };
    };
    systemd.services.forgejo.after = [ "zfs-mount.service" ];
    systemd.services.forgejo.requires = [ "zfs-mount.service" ];

    services.nginx.virtualHosts."git.${cfg.domain}" = {
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

