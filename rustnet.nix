{ craneLib, pkgs, lib, fetchFromGitHub }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.zlib] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap pkgs.elfutils]);
  version = "1.7.0-unstable-2026-11-09";
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    rev = "218e16d51b62a344bcedc94313a35b21aebe8edc";
    hash = "sha256-dR227uInXloEv/WF0jxyId4yNqN+tvDy5dyWjQJoPSE=";
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
