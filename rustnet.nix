{ craneLib, pkgs, lib, fetchFromGitHub }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.zlib] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap pkgs.elfutils]);
  version = "1.7.0-unstable-2026-10-13";
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    rev = "b0f60eba7a6fe97d575e54b2d2a60d8e4b35f6a4";
    hash = "sha256-PZODP6lI71NeWronlAc5bB053RtcHHZ0QsOnLcwUnRM=";
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
