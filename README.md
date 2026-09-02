# NixConf

pgattic's NixOS configs and packages

## Usage

Adding a device:

1. Install NixOS the normal way on the device
2. Ensure the following options are set in `/etc/nixos/configuration.nix`, then do a `sudo nixos-rebuild switch`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [ git neovim nh ];
```
3. `git clone https://github.com/pgattic/nixconf`
4. Add a directory in [`/parts/hosts/`](/parts/hosts/) for the new device, and copy `/etc/nixos/hardware-configuration.nix` to the new dir under the name `_hardware.nix`.
5. Add a `default.nix` in the new directory with the example minimal configuration:
```nix
{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.new-computer = withSystem "x86_64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.browser
      ({ pkgs, ... }: {
        networking.hostName = "new-computer";
        system.stateVersion = "25.05";

        environment.systemPackages = [
          self'.packages.foot
          pkgs.rnote
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          # Customized Niri package
          package = (self'.packages.niri-noctalia5-activate-linux.apply {
            settings.outputs."eDP-1".scale = 1.5;
          }).wrapper;
        };
      })
    ];
  });
}
```
6. Rebuild the system with `nh os switch /home/pgattic/nixconf#new-computer` (subsequent rebuilds can be done with simply `nh os switch`)
7. (Optional) to set up remote building, include the `remote-builder` module, then generate a root-level ssh key to paste into `keys.builder` in `./parts/globals.nix`:
```bash
sudo ssh-keygen -t ed25519 -f /root/.ssh/nixbuilder_ed25519 -C "nixbuilder-new-computer"
sudo cat /root/.ssh/nixbuilder_ed25519.pub | wl-copy
```

## Notes

- With a remote builder, some packages which have a `preferLocalBuild` option may still build locally. Force a remote build with `--option max-jobs 0`, and force a local build with `--option builders ''`.
