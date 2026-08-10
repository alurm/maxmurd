{
  description = "Max Mur's D";

  inputs = {
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      flake.nixosModules.maxmurd = ./delayed/nixos.nix;
      perSystem =
        { pkgs, ... }:
        rec {
          packages.maxmurd = pkgs.writeText "maxmurd" (builtins.readFile ./README.md);
          packages.default = packages.maxmurd;
        };
    };
}
