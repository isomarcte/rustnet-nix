# Justfile for rustnet-nix

# Update everything: flake inputs, then rustnet only if rustnet or its build
# inputs (nixpkgs, rust-overlay, crane) actually changed
update:
    #!/usr/bin/env bash
    set -euo pipefail
    build_inputs='.nodes.nixpkgs.locked.rev, .nodes["rust-overlay"].locked.rev, .nodes.crane.locked.rev'
    before=$(jq -r "$build_inputs" flake.lock)
    just update-nix
    after=$(jq -r "$build_inputs" flake.lock)
    current_version=$(rg -oP '(?<=version = ")[^"]+' rustnet.nix)
    latest_tag=$(curl -sf https://api.github.com/repos/domcyrus/rustnet/releases/latest | jq -r '.tag_name')
    latest_version=${latest_tag#v}
    if [ "$before" != "$after" ] || [ "$current_version" != "$latest_version" ]; then
        just update-rustnet
    else
        echo "rustnet and its build inputs are unchanged; skipping update-rustnet"
    fi

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

# Update rustnet to the latest tagged release
update-rustnet:
    nix-update --flake rustnet --version stable --use-github-releases
