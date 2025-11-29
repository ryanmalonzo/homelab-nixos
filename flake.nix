{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs =
    {
      nixpkgs,
      quadlet-nix,
      home-manager,
      ...
    }:
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        };

        nixos = {
          deployment.targetHost = "homelab-nixos";
          deployment.targetUser = "ryan";
          deployment.buildOnTarget = true;

          imports = [
            ./hosts/nixos/configuration.nix
            ./hosts/nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            quadlet-nix.nixosModules.quadlet
          ];

          _module.args = {
            inherit quadlet-nix;
          };
        };
      };
    };
}
