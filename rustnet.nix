{ craneLib, pkgs, lib, fetchFromGitHub }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.zlib] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap pkgs.elfutils]);
  version = "1.7.0-unstable-2026-10-26";
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    rev = "213d43cdc0057b41e5e4bd0e1fbdb5b3d100fe75";
    hash = "sha256-Wmy13qHvRij6J7N7nS2wQlWrHxjaLMgwywx5dkfGHGU=";
  };
  pkg = craneLib.buildPackage {
    pname = "rustnet";
    inherit version src;

    doCheck = false;

    nativeBuildInputs = nbi;

    buildInputs = bi;

    hardeningDisable = if isDarwin then [] else [ "zerocallusedregs" ];

    meta = {
      description = "A cross-platform network monitoring terminal UI tool built with Rust.";
      homepage = "https://github.com/domcyrus/rustnet";
      license = lib.licenses.asl20;
      maintainers = [ ];
    };
  };
in
# Re-set so builtins.unsafeGetAttrPos points to this file for nix-update
pkg.overrideAttrs { inherit version src; }
