{
  flake = {
    desktop = {
      opacity = 0.85;
      corner-radius = 12.0;
    };
    server = {
      domain = "corlessfamily.net";
      paths = {
        storage = "/tank";
        media = "/tank/media";
        appdata = "/tank/appdata";
        store = "/tank/store";
        secrets = "/tank/secrets";
      };
    };
    keys = {
      ssh = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com" # t480
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0Qx8iBekJ07LRxUsDNm0bcSkilw7xX51LYrzz6F4xx pgattic@gmail.com" # mbair
      ];
      builder = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfNeGvgeuyLKrAzgAsfKUhpHwB9AwwdO49WgKlkqTw+ nixbuilder-mbair"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0S/bzInee4MQiTANd23jCRTbu/Lz50KgU15+iJtbxP nixbuilder-op6"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWIqPifAxRsDOdVuApg1S2mE7y3sf8xOnO6bodTjKIT nixbuilder-surface"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtBb1uGEGrRgl8OXt+iue4bwKUSj1m5adq2n7NziyY8 nixbuilder-t480"
      ];
    };
  };
}
