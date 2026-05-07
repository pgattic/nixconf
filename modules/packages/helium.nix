{
  perSystem = { lib, pkgs, ... }: let
    pname = "helium";
    version = "0.12.1.1";

    architectures = {
      "x86_64-linux" = {
        arch = "x86_64";
        hash = "sha256-+UE+JqQtxbA5szPvAohapXlES21VBOdNsV6Ej1dRRfs=";
      };
      "aarch64-linux" = {
        arch = "arm64";
        hash = "sha256-8TJ/1alUtEM7KgZOdc8cmVkIXjKdBbxtEZhO/08Pouo=";
      };
    };

    src = let
      inherit (architectures.${pkgs.stdenv.hostPlatform.system}) arch hash;
    in pkgs.fetchurl {
      inherit hash;
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
    };
    appimageContents = pkgs.appimageTools.extract {
      inherit pname version src;
    };
  in {
    packages.helium = pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      dieWithParent = false;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/helium.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail "Exec=helium" "Exec=$out/bin/${pname}"
        install -m 444 -D ${appimageContents}/helium.png \
          $out/share/icons/hicolor/256x256/apps/${pname}.png
      '';
      meta.platforms = lib.attrNames architectures;
    };
  };
}
