#!/usr/bin/env bash
# Update mdx-language-server to the latest npm release.
#
# The published tarball ships without a package-lock.json, so we generate one
# from its package.json, then refresh the version, src hash and npmDepsHash in
# default.nix. No-op when already on the latest version.
set -euo pipefail

# Re-exec inside a shell that has every tool we need, so the script behaves the
# same on darwin and NixOS regardless of what's installed globally.
if [[ -z "${MDX_UPDATE_SHELL:-}" ]]; then
  export MDX_UPDATE_SHELL=1
  exec nix shell nixpkgs#nodejs nixpkgs#prefetch-npm-deps nixpkgs#jq nixpkgs#gnused nixpkgs#curl \
    --command bash "$0" "$@"
fi

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nix_file="$dir/default.nix"
registry="https://registry.npmjs.org/@mdx-js/language-server"

current=$(sed -n '/^  mdx-language-server = /,/^  };/s/^ *version = "\(.*\)";/\1/p' "$nix_file" | head -1)
latest=$(curl -fsSL "$registry/latest" | jq -r .version)

if [[ "$current" == "$latest" ]]; then
  echo "mdx-language-server is up to date ($current)"
  exit 0
fi
echo "mdx-language-server: $current -> $latest"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

tarball_url="$registry/-/language-server-$latest.tgz"
src_hash=$(nix store prefetch-file --json --hash-type sha256 "$tarball_url" | jq -r .hash)

curl -fsSL "$tarball_url" | tar xz -C "$work"
# Run from inside the package dir: --prefix trips over macOS's /var ->
# /private/var symlink and bakes bogus relative paths into the lockfile.
(cd "$work/package" && npm install --package-lock-only --ignore-scripts --no-audit --no-fund >/dev/null)

old_lock="$dir/mdx-language-server-$current-package-lock.json"
new_lock="$dir/mdx-language-server-$latest-package-lock.json"
cp "$work/package/package-lock.json" "$new_lock"
deps_hash=$(prefetch-npm-deps "$new_lock" 2>/dev/null)

# Only touch the mdx-language-server block; other derivations in this file have
# their own version/sha256 attributes.
sed -i \
  -e "/^  mdx-language-server = /,/^  };/{
        s|^\( *version = \)\"[^\"]*\";|\1\"$latest\";|
        s|^\( *sha256 = \)\"[^\"]*\";|\1\"$src_hash\";|
        s|^\( *npmDepsHash = \)\"[^\"]*\";|\1\"$deps_hash\";|
        s|mdx-language-server-[0-9][0-9.]*-package-lock\.json|mdx-language-server-$latest-package-lock.json|
      }" \
  "$nix_file"

# Flakes only see git-tracked files, so stage the new lockfile and drop the old.
git -C "$dir" add "$new_lock"
if [[ -e "$old_lock" ]]; then
  git -C "$dir" rm -q --cached "$old_lock" 2>/dev/null || true
  rm -f "$old_lock"
fi

echo "Updated mdx-language-server to $latest"
