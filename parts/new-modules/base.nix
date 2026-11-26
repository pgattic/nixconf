{ self, inputs, ... }: {
  flake.nixosModules.new-default = { config, lib, pkgs, ... }: let
    cfg = config.nixconf;
  in {
    imports = [
      inputs.bootmap.nixosModules.default
    ];

    options.nixconf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable nixconf stuff";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "pgattic";
        description = "Which user to apply nixconf to";
      };
      swapfile = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable a swapfile with zswap";
        };
        size = lib.mkOption {
          type = lib.types.int;
          default = 16 * 1024;
          description = "Swapfile size in MiB";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      nixpkgs = {
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "ventoy-1.1.10"
        ];
      };

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;
      # Allow NixOS to add itself to bootloader options
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
      # Don't kill the user session when I rebuild
      services.logind.settings.Login.killUserProcesses = lib.mkDefault false;
      # systemd.services."systemd-logind".restartIfChanged = lib.mkDefault false;
      boot.zswap.enable = lib.mkDefault (config.swapDevices != [ ]);
      swapDevices = lib.mkIf cfg.swapfile.enable [{
        device = "/var/lib/swapfile";
        size = cfg.swapfile.size;
      }];

      time.timeZone = self.lib.general.time-zone;
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = ["root" "@wheel" ];
        substituters = lib.mkAfter [
          "https://vladexa.cachix.org"
        ];
        trusted-public-keys = lib.mkAfter [
          "vladexa.cachix.org-1:ThmpOQRxh92xt3RMgUA5XOEklLhW1pLQa5lPTREozO4="
        ];
      };

      services = {
        fwupd.enable = lib.mkDefault true;
        openssh.package = pkgs.openssh_hpn;
      };
    };
  };
}
