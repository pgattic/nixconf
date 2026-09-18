{
  perSystem = { pkgs, ... }: {
    packages.wvkbd-deskintl = pkgs.wvkbd.overrideAttrs (old: {
      pname = "wvkbd-deskintl";
      meta = (old.meta or {}) // { mainProgram = "wvkbd-deskintl"; };
      postPatch = (old.postPatch or "") + ''
        substituteInPlace config.mk \
          --replace 'LAYOUT = mobintl' 'LAYOUT = deskintl'
      '';
    });
  };
}
