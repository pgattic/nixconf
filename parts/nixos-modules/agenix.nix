{ inputs, ... }: {
  flake.nixosModules.agenix = { pkgs, ... }: {
    imports = [
      inputs.agenix.nixosModules.default
    ];
    age.secrets = {
      qbittorrent-pass = {
        file = ../../secrets/qbittorrent-pass.age;
        owner = "qbittorrent"; group = "qbittorrent"; mode = "0400";
      };
      namecheap-dns-env = {
        file = ../../secrets/namecheap-dns-env.age;
        owner = "root"; group = "root"; mode = "0400";
      };
      copyparty-pgattic = {
        file = ../../secrets/copyparty-pgattic.age;
        owner = "copyparty"; group = "copyparty"; mode = "0400";
      };
      copyparty-skylar = {
        file = ../../secrets/copyparty-skylar.age;
        owner = "copyparty"; group = "copyparty"; mode = "0400";
      };
      copyparty-jstucor = {
        file = ../../secrets/copyparty-jstucor.age;
        owner = "copyparty"; group = "copyparty"; mode = "0400";
      };
    };
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
