{ craneLib, pkgs, lib, fetchFromGitHub }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.zlib] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap pkgs.elfutils]);
  version = "1.7.0-unstable-2026-10-09";
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    rev = "e2e3f9c8b824d034bf8feff1907e92becd4116a1";
    hash = "sha256-aivdOxjCOujQOrCcUYhxXsHKhE1yojuNL6PDeljR3MI=";
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
