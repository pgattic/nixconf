{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.rg35xx-h = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      inputs.anbernix.nixosModules.anbernic-rg35xx-h
      inputs.anbernix.nixosModules.anbernic-h700-sd-image
      inputs.anbernix.nixosModules.anbernic-h700-retroarch
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default

      ({ lib, pkgs, ... }: let
        niri-pkg = (self'.packages.niri-noctalia5.apply {
          settings.outputs."DSI-1".scale = 0.75;
        }).wrapper;
      in {
        networking.hostName = "rg35xx-h";
        nixpkgs.hostPlatform = "aarch64-linux";
        system.stateVersion = "25.05";

        users.users.pgattic = {
          isNormalUser = true;
          extraGroups = [ "wheel" "input" "video" "audio" "uinput" "networkmanager" ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0Qx8iBekJ07LRxUsDNm0bcSkilw7xX51LYrzz6F4xx pgattic@gmail.com"
          ];
        };
        boot.supportedFilesystems.zfs = lib.mkForce false;

        boot = {
          initrd = {
            availableKernelModules = [ "usbhid" "hid" "evdev" "uinput" ];
            allowMissingModules = true;
            systemd.enable = false;
          };
          loader = {
            systemd-boot.enable = false;
            grub.enable = false;
            generic-extlinux-compatible = {
              enable = true;
              configurationLimit = 2;
            };
          };
          kernelParams = [ "console=tty0" ];
          zfs.forceImportRoot = false;
        };
        systemd.enableStrictShellChecks = lib.mkForce false;

        sdImage.compressImage = true;
        fileSystems."/".options = [ "noatime" ];

        hardware.graphics.enable = true;
        security.rtkit.enable = true;
        security.sudo.wheelNeedsPassword = false;

        swapDevices = lib.mkForce [{
          device = "/var/lib/swapfile";
          size = 4*1024; # 4 GiB
        }];

        services = {
          fwupd.enable = false;
          greetd = {
            enable = true;
            settings.default_session = lib.mkForce {
              command = "${lib.getExe niri-pkg}";
              user = "pgattic";
            };
          };
          pipewire = {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
          };
          openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              PermitRootLogin = "no";
            };
          };
          inputplumber.enable = true;
        };

        environment.systemPackages = [
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          self'.packages.inputplumber-rg35xx-h
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.lazygit
          pkgs.kopuz
          pkgs.inputplumber
        ];
        environment.pathsToLink = [
          "/share/inputplumber"
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = niri-pkg;
        };
      })
    ];
  });
}
