{ inputs, self, ... }: let port = 6234; in {
  flake.nixosModules.scripguessr = { lib, config, ... }: {
    imports = [
      inputs.scripguessr.nixosModules.default
    ];

    services.scripguessr = {
      enable = true;
      port = port;
      hostName = "scripguessr.${self.lib.server.domain}";
      environmentFile = "/tank/secrets/scripguessr/runtime.env";
      configureNginx = false;
    };

    # Keep the Rust database intact; Phoenix uses a separate database.
    services.postgresql.ensureDatabases = [ "scripguessr_phoenix" ];
    systemd.services.postgresql-setup.postStart = lib.mkAfter ''
      psql --host=/run/postgresql --port=${toString config.services.postgresql.settings.port} \
        --dbname=postgres --set=ON_ERROR_STOP=1 \
        --command='ALTER DATABASE "scripguessr_phoenix" OWNER TO "scripguessr";'
    '';
    systemd.services.scripguessr.environment.PGDATABASE = lib.mkForce "scripguessr_phoenix";

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
