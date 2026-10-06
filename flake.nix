{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nix-wrapper-modules = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:sempiternal-aurora/nixos-apple-silicon/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "nur";
      inputs.flake-parts.follows = "flake-parts";
      inputs.gnome-shell.follows = "";
    };
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wasmcarts = {
      url = "github:pgattic/wasm-experiment";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.blocksds-nix.follows = "";
      inputs.devkitNix.follows = "";
    };
    dark-text-src = {
      url = "github:vimjoyer/dark-text";
      flake = false;
    };
    barp = {
      url = "github:pgattic/barp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scripguessr = {
      url = "github:pgattic/scripguessr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    anbernix.url = "github:AmazinAxel/anbernix";
    asahix.url = "github:skiletro/asahix";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    imports = [
      inputs.home-manager.flakeModules.home-manager
      (inputs.import-tree ./parts)
    ];
  };
}
