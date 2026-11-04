{
  perSystem =
    { pkgs, self', ... }:
    with pkgs;
    let
      src = fetchFromGitHub {
        owner = "horizon-rust";
        repo = "horizon";
        rev = "2a8c60b6df5d837c4ac4bd56bfc92c9d88a9bd8e";
        hash = "sha256-7+Mdwsn3vX7Tnzq9eczV4n+K05z8TBsue6kOr8faaSk=";
      };
    in {
      packages.horizon-game-unwrapped = rustPlatform.buildRustPackage (finalAttrs: {
        pname = "horizon-game";
        version = "0-unstable-2a8c60b";
        inherit src;

        cargoHash = "sha256-pzFa4gzAiTWYPizmo3v0QFNetsu0HhmY9i44YdRZZ0U=";
        cargoBuildFlags = [
          "-p"
          "horizon-client"
          "-p"
          "horizon-prepare"
          "--bins"
        ];

        nativeBuildInputs = [
          pkg-config
          makeWrapper
        ];

        buildInputs = [
          alsa-lib
          udev
          libGL
          libx11
          libxcursor
          libxi
          libxrandr
          libxkbcommon
          vulkan-loader
          wayland
        ];

        env.HORIZON_VERSION = "local-2a8c60b";

        # Upstream's game tests need a separately prepared copy of Minecraft.
        doCheck = false;

        installPhase = ''
          runHook preInstall

          for binary in horizon-client horizon-ctl horizon-prepare; do
            install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/$binary $out/bin/$binary
            wrapProgram $out/bin/$binary \
              --prefix PATH : ${lib.makeBinPath [ jdk25 ]} \
              --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
          done

          # A writable copy of these files forms a local launcher version. Prepared
          # resources are generated there at runtime, outside the Nix store.
          mkdir -p $out/share/horizon
          cp -r --parents research-lock.json mods/horizon/src/test/java \
            crates/horizon-prepare $out/share/horizon/

          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck
          $out/bin/horizon-client --help > /dev/null
          $out/bin/horizon-ctl --help > /dev/null
          $out/bin/horizon-prepare --version
          runHook postInstallCheck
        '';

        passthru.launcherVersion = "local-2a8c60b";

        meta = {
          description = "Native Horizon game and resource preparation tools";
          homepage = "https://playhorizon.dev";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ cleboost ];
          mainProgram = "horizon-client";
          platforms = lib.platforms.linux;
        };
      });

      packages.horizon-game =
        let
          game = self'.packages.horizon-game-unwrapped;
        in
        symlinkJoin {
          name = game.name;
          paths = [
            game
            (writeShellScriptBin "horizon-game" ''
              set -eu
              game_home="''${HORIZON_HOME:-''${XDG_DATA_HOME:-$HOME/.local/share}/horizon}"
              launcher_home="''${HORIZON_LAUNCHER_HOME:-''${XDG_DATA_HOME:-$HOME/.local/share}/horizon-launcher}"
              resources="''${HORIZON_RESOURCES:-$launcher_home/versions/${game.launcherVersion}/.local/horizon-client/26.3}"
              mkdir -p "$game_home"
              cd "$game_home"
              exec ${game}/bin/horizon-client --resources "$resources" "$@"
            '')
          ];
          passthru = {
            inherit (game) launcherVersion;
            unwrapped = game;
          };
          meta = game.meta // {
            mainProgram = "horizon-game";
          };
        };
    };
}
