{ inputs, self, ... }: let port = 6234; in {
  flake.nixosModules.scripguessr = {
    imports = [
      inputs.scripguessr.nixosModules.default
    ];

    services.scripguessr = {
      enable = true;
      port = port;
    };

    services.nginx.virtualHosts."scripguessr.${self.lib.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
      };
    };
  };
}
