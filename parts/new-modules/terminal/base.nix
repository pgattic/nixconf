{ moduleWithSystem, ... }: {
  flake.nixosModules.new-default = moduleWithSystem ({ self', ... }: { config, lib, pkgs, ... }: let
    cfg = config.nixconf.terminal;
  in {
    options.nixconf.terminal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.nixconf.enable;
        description = "Whether to enable terminal features";
      };
      useDefaultApps = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include default terminal applications";
      };
      apps = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Terminal applications to inject into the shell";
      };
      editor = lib.mkOption {
        type = lib.types.package;
        default = self'.packages.neovim;
        description = "The user's editor package";
      };
      shell = lib.mkOption {
        type = lib.types.package;
        default = (self'.packages.nushell.apply ({ lib, ... }: {
          env.EDITOR = lib.getExe cfg.editor;
          runtimePkgs = [ cfg.editor ] ++ cfg.apps;
        })).wrapper;
        description = "The user's shell package";
      };
    };

    config = lib.mkIf cfg.enable {
      nixconf.terminal.apps = lib.mkIf cfg.useDefaultApps [
        self'.packages.btop
        self'.packages.fastfetch
        self'.packages.nh
        self'.packages.git

        pkgs.lazygit
        pkgs.bat
        pkgs.openssh_hpn
        pkgs.ripgrep
        pkgs.less
        pkgs.jq
        pkgs.usbutils
        pkgs.gdu
        pkgs.file
        pkgs.tree
        pkgs.ouch # Archive manager
        pkgs.tinyxxd
        pkgs.nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands
      ];

      users.users.${config.nixconf.user} = {
        shell = cfg.shell;
        packages = lib.mkIf config.nixconf.desktop.enable [
          (self'.packages.foot-base.apply ({ lib, ... }: {
            env.SHELL = lib.getExe cfg.shell;
          })).wrapper
        ];
      };
    };
  });
}
