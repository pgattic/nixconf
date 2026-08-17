{ self, ... }: let port = 8082; in {
  flake.nixosModules.traccar = {
    services.traccar = {
      enable = true;
      settings = {
        web.port = builtins.toString port;
      };
    };

    services.nginx.virtualHosts."traccar.${self.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
}
