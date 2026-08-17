{ self, ... }: let port = 2285; in {
  flake.nixosModules.forgejo = { pkgs, ... }: {
    services.forgejo = {
      enable = true;
      package = pkgs.forgejo; # Defaults to forgejo-lts
      stateDir = "/tank/store/forgejo";
      settings = {
        server = rec {
          DOMAIN = "git.${self.server.domain}";
          ROOT_URL = "https://${DOMAIN}/";
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

    services.nginx.virtualHosts."git.${self.server.domain}" = {
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
