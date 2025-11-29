{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
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
        ];
      };
    };
  };
}
