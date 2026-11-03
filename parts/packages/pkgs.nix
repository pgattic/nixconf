{
  perSystem = { pkgs, ... }: {
    packages = {
      horizon-launcher = pkgs.callPackage ./_pkgs/horizon-launcher.nix { };
      horizon-server = pkgs.callPackage ./_pkgs/horizon-server.nix { };
    };
  };
}
