# Justfile for rustnet-nix

# Update everything
update: update-nix update-rustnet

# Update flake inputs
update-nix:
    nix flake update

# Build the default package
build:
    nix build

# Format all files via treefmt
fmt:
    nix fmt

# Check formatting without writing changes
fmt-check:
    treefmt --fail-on-change

# Update rustnet to the latest version
update-rustnet:
    nix-update --flake rustnet --version branch
