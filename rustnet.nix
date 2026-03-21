{ pkgs, lib, fetchFromGitHub, rustPlatform }:

let 
  isDarwin = pkgs.stdenv.isDarwin;
  nbi = [pkgs.clang pkgs.pkg-config];
  bi = [pkgs.elfutils pkgs.zlib pkgs.libbpf] ++ (if isDarwin then [pkgs.darwin.libpcap] else [pkgs.libpcap]);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustnet";
  version = "1.1.0";

  doCheck = false;

  nativeBuildInputs = nbi;

  buildInputs = bi;

  hardeningDisable = if isDarwin then [] else [ "zerocallusedregs" ];
  
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8H6n9dUo7zRKT8Lp1dN1RJ3bR99GaTeXb0mL4YrXtRA=";
  };

  cargoHash = "sha256-k+L0aVsu2p7paiowQn0HlCXBCzKlXlZT49Qu2fypNCs=";

  meta = {
    description = "A cross-platform network monitoring terminal UI tool built with Rust.";
    homepage = "https://github.com/domcyrus/rustnet";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
