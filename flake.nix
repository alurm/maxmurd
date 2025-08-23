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
      perSystem =
        { pkgs, config, ... }:
        {
          packages = {
            maxmurd = pkgs.writeText "maxmurd" (builtins.readFile ./data);
            maxmurd-readme = pkgs.writeText "maxmurd-readme" ''
              # Max Mur's D

              ```maxmur
              ${builtins.readFile config.packages.maxmurd}
              ```
            '';
          };
        };
    };
}
