{
  description = "Flake for rustnet-nix";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
  };

  outputs = inputs@{ devshell, treefmt-nix, flake-parts, rust-overlay, crane, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.easyOverlay
        treefmt-nix.flakeModule
        devshell.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          overlays = [ rust-overlay.overlays.default ];
          pkgs' = import inputs.nixpkgs { inherit system overlays; };
          rustToolchain = pkgs'.rust-bin.stable.latest.default;
          craneLib = (crane.mkLib pkgs').overrideToolchain rustToolchain;
          rustnet = pkgs'.callPackage ./rustnet.nix { inherit craneLib; };
        in {
          packages.default = rustnet;
          packages.rustnet = rustnet;

          treefmt.config = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.just.enable = true;
          };

          devshells.default = {
            commands = [
              {
                package = rustnet;
              }
            ];
            packages = [
              rustToolchain
              pkgs.just
              pkgs.nix-update
            ];
          };
        };
      flake = {};
    };
}
