{ self, ... }: {
  flake.nixosModules.yubal = { ... }: let
    port = 6767;
    lanCidr = "192.168.1.0/24";
    uid = 987;
    gid = 987;
  in {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";

    users.groups.yubal.gid = gid;
    users.users.yubal = {
      isSystemUser = true;
      group = "yubal";
      uid = uid;
      extraGroups = [ "media" ];
    };

    virtualisation.oci-containers.containers.yubal = {
      image = "ghcr.io/guillevc/yubal:latest";
      autoStart = true;
      ports = [ "${toString port}:${toString port}" ];
      volumes = [
        "${self.lib.server.paths.media}/music:/app/data"
        "${self.lib.server.paths.appdata}/yubal:/app/config"
      ];
      environment = {
        PUID = toString uid;
        PGID = toString gid;
        YUBAL_HOST = "0.0.0.0";
        YUBAL_PORT = toString port;
        YUBAL_TZ = self.lib.general.time-zone;
        YUBAL_AUDIO_FORMAT = "opus";
        YUBAL_SCHEDULER_CRON = "0 3 * * *";
        YUBAL_DOWNLOAD_UGC = "false";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${self.lib.server.paths.appdata}/yubal 0750 yubal yubal -"
      "z ${self.lib.server.paths.media}/music 2775 root media - -"
    ];

    networking.firewall.extraInputRules = ''
      ip saddr ${lanCidr} tcp dport ${toString port} accept
    '';
  };
}
