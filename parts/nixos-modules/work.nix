{
  flake.nixosModules.work = { lib, pkgs, ... }: {
    environment.systemPackages = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then [
      pkgs.slack
    ] else [
      pkgs.slacky
    ];
    # For doing terminals through USB
    users.users.pgattic.extraGroups = lib.mkAfter [
      "dialout"
    ];
  };
}
