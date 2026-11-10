{
  perSystem = { pkgs, ... }: {
    packages = {
      # https://github.com/NixOS/nixpkgs/pull/580999
      horizon-launcher = pkgs.callPackage ./_pkgs/horizon-launcher.nix { };
      horizon-server = pkgs.callPackage ./_pkgs/horizon-server.nix { };
    };
  };
}
