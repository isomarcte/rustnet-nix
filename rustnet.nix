{ craneLib, pkgs, lib, fetchFromGitHub }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.zlib] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap pkgs.elfutils]);
  version = "1.7.0-unstable-2026-10-22";
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    rev = "71409f1b013fc1ebf87cb5f936e841654f2d7c7e";
    hash = "sha256-ni9Ze1uEhALLUY2+K1g1be6EIiGQib1Qpqp0bxUm8MM=";
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
