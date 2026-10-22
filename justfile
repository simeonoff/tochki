# Tochki – flake validation and package updates
# Everything else (clean, os switch) is covered by `nh`.

# Bump hand-packaged derivations that flake inputs don't cover.
update-packages:
    ./packages/language-servers/update-mdx.sh

# Update flake inputs and hand-packaged derivations, then switch home.
switch: update-packages
    nh home switch --update

# Evaluate all flake outputs and run any bundled tests.
check:
    nix flake check

# Quick structural check without building derivations.
check-fast:
    nix flake check --no-build
