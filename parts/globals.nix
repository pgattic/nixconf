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
  };
}
