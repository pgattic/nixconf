{
  flake.nixosModules.user = {
    users.users.pgattic = {
      isNormalUser = true;
      extraGroups = [ "wheel" "input" ];
      description = "Preston Corless";
    };
  };
}
