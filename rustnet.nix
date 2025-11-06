{ pkgs, lib, fetchFromGitHub, rustPlatform }:

let 
  libpcap = if pkgs.stdenv.isDarwin then pkgs.darwin.libpcap else pkgs.libpcap;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustnet";
  version = "0.15.0";

  doCheck = false;

  buildInputs = [
    libpcap
  ];
  
  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HodiHSOTOAb5vRqkeyE3TGNNmUumJfBeYJeNs6vFRas=";
  };

  cargoHash = "sha256-uSAMjEuoB9a2dftKq/KhnzhEzb+fF51RLJ/Hsmo1wIM=";

  meta = {
    description = "A cross-platform network monitoring terminal UI tool built with Rust.";
    homepage = "https://github.com/domcyrus/rustnet";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
