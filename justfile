# Tochki – flake validation
# Everything else (switch, update, clean) is covered by `nh`.

# Evaluate all flake outputs and run any bundled tests.
check:
    nix flake check

# Quick structural check without building derivations.
check-fast:
    nix flake check --no-build
