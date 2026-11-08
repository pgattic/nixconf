{ self, ... }: {
  flake.nixosModules.minecraft-java-server = { pkgs, ... }: {
    services.minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      # Keep this world on 26.3 even when Nixpkgs' default version changes.
      package = pkgs.minecraftServers.vanilla-26-3;
      dataDir = "${self.lib.server.paths.appdata}/minecraft-java";
      jvmOpts = "-Xms1G -Xmx4G";
      # Offline UUIDs are derived from "OfflinePlayer:<name>" with exact casing.
      whitelist = {
        Player32522 = "1ec91ce9-134f-3864-81b4-6fe0ce338e75";
        Player38350 = "09914081-94ee-3174-a6d5-30d2ce42f54d";
        pgattic = "89650b50-52d1-3596-9543-9b119eaa64ad";
      };
      serverProperties = {
        server-port = 25565;
        motd = "Corless Family Minecraft Java 26.3";
        gamemode = "survival";
        difficulty = "easy";
        max-players = 15;
        online-mode = false;
        white-list = true;
        enforce-whitelist = true;
        enable-rcon = false;
        enable-query = false;
      };
    };

    systemd.services.minecraft-server = {
      after = [ "zfs-mount.service" ];
      requires = [ "zfs-mount.service" ];
    };

    networking.firewall.allowedTCPPorts = [ 25565 ];
  };
}
