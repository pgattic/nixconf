{
  flake.nixosModules.remote-builder = { config, lib, ... }: lib.mkIf (config.networking.hostName != "corlessfam") {
    # Usage:
    # 1. Generate an SSH key on the client machine with this command:
    #    `sudo ssh-keygen -t ed25519 -f /root/.ssh/nixbuilder_ed25519 -C "nixbuilder-$(hostname)"`
    # 2. Copy the new public key to the list of trusted SSH keys on corlessfam's config and rebuild corlessfam:
    #    `sudo cat /root/.ssh/nixbuilder_ed25519.pub | wl-copy`
    # 3. Include this module on the client's NixOS config and rebuild the client
    # 4. SSH into corlessfam's remote builder user once to add it to the client's trusted hosts list:
    #    `sudo ssh -i /root/.ssh/nixbuilder_ed25519 nixbuilder@corlessfamily.net`
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "corlessfamily.net";
          protocol = "ssh-ng";
          sshUser = "nixbuilder";
          sshKey = "/root/.ssh/nixbuilder_ed25519";
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          maxJobs = 4;
          speedFactor = 2;
          supportedFeatures = [ "big-parallel" ];
        }
      ];

      settings = {
        builders-use-substitutes = true;
        max-jobs = lib.mkDefault 1;
      };
    };
  };
}
