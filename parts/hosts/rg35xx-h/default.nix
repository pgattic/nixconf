{ inputs, self, withSystem, ... }: {
  flake.nixosConfigurations.rg35xx-h = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      inputs.anbernix.nixosModules.anbernic-rg35xx-h
      inputs.anbernix.nixosModules.anbernic-h700-sd-image
      inputs.anbernix.nixosModules.anbernic-h700-retroarch
      inputs.self.nixosModules.new-default

      ({ lib, pkgs, ... }: let
        niri-pkg = (self'.packages.niri.apply {
          settings.outputs."DSI-1".scale = 0.75;
        }).wrapper;
      in {
        networking.hostName = "rg35xx-h";
        nixpkgs.hostPlatform = "aarch64-linux";
        system.stateVersion = "25.05";

        users.users.pgattic = {
          isNormalUser = true;
          extraGroups = [ "wheel" "input" "video" "audio" "uinput" "networkmanager" ];
          openssh.authorizedKeys.keys = self.lib.keys.ssh;
        };
        boot.supportedFilesystems.zfs = lib.mkForce false;

        boot = {
          initrd = {
            availableKernelModules = [ "usbhid" "hid" "evdev" "uinput" ];
            allowMissingModules = true;
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

        nixconf = {
          swapfile.size = 4*1024; # 4 GiB
          desktop.enable = false; # This host does things manually
        };

        services = {
          fwupd.enable = false;
          greetd = {
            enable = true;
            settings.default_session = lib.mkForce {
              command = "${niri-pkg}/bin/niri-session";
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
          self'.packages.git
          self'.packages.inputplumber-rg35xx-h
          self'.packages.helium
          pkgs.lazygit
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
        programs.noctalia = {
          enable = true;
          package = self'.packages.noctalia;
          systemd.enable = true;
        };
      })
    ];
  });
}
