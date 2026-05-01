{
  flake.nixosModules.work = { config, lib, pkgs, ... }: {
    environment.systemPackages = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then [
      pkgs.slack
    ] else [
      pkgs.slacky
    ];
    # For doing terminals through USB
    users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
      "dialout"
    ];
  };
}

