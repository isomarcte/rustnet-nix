{ pkgs, lib, fetchFromGitHub, rustPlatform }:

let 
  libpcap = if pkgs.stdenv.isDarwin then pkgs.darwin.libpcap else pkgs.libpcap;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustnet";
  version = "0.18.0";

  doCheck = false;

  nativeBuildInputs = [
    pkgs.clang
    pkgs.elfutils
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.libbpf
    pkgs.zlib
    libpcap
    pkgs.elfutils
  ];

  hardeningDisable = [ "zerocallusedregs" ];
  
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79mYmb5gvqpjuLweEL+RJIf1jlfypO5zV1VC+BEeyp0=";
  };

  cargoHash = "sha256-ULYy4uCwmlOEO+Nlt3GO3cB891BOn9hUIfvr4UfeVzs=";

  meta = {
    description = "A cross-platform network monitoring terminal UI tool built with Rust.";
    homepage = "https://github.com/domcyrus/rustnet";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
