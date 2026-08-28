{
  flake = {
    theme = {
      # Da one gray colors
      base00 = "181818";
      base01 = "282828";
      base02 = "585858";
      base03 = "888888";
      base04 = "c8c8c8";
      base05 = "ffffff";
      base06 = "ffffff";
      base07 = "ffffff";
      base08 = "fa7883";
      base09 = "ffc387";
      base0A = "ff9470";
      base0B = "98c379";
      base0C = "8af5ff";
      base0D = "6bb8ff";
      base0E = "e799ff";
      base0F = "b3684f";

      # Foot colors
      # base00 = "000000";
      # base01 = "cd3131";
      # base02 = "0dbc79";
      # base03 = "e5e510";
      # base04 = "2472c8";
      # base05 = "bc3fbc";
      # base06 = "11a8cd";
      # base07 = "e5e5e5";
      # base08 = "666666";
      # base09 = "f14c4c";
      # base0A = "23d18b";
      # base0B = "f5f543";
      # base0C = "3b8eea";
      # base0D = "d670d6";
      # base0E = "29b8db";
      # base0F = "e5e5e5";
    };
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
      ssh = [ # ssh-keygen -t ed25519 -C "pgattic@gmail.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com" # t480
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0Qx8iBekJ07LRxUsDNm0bcSkilw7xX51LYrzz6F4xx pgattic@gmail.com" # mbair
      ];
      builder = [ # See nixos-modules/remote-builder.nix for more info
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfNeGvgeuyLKrAzgAsfKUhpHwB9AwwdO49WgKlkqTw+ nixbuilder-mbair"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0S/bzInee4MQiTANd23jCRTbu/Lz50KgU15+iJtbxP nixbuilder-op6"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWIqPifAxRsDOdVuApg1S2mE7y3sf8xOnO6bodTjKIT nixbuilder-surface"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtBb1uGEGrRgl8OXt+iue4bwKUSj1m5adq2n7NziyY8 nixbuilder-t480"
      ];
    };
  };
}
