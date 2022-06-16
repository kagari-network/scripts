#!/usr/bin/env bash
set -e

# check groupadd useradd curl git

if ! command -v nix > /dev/null; then
    . ~/.nix-profile/etc/profile.d/nix.sh || true
fi

if ! command -v nix > /dev/null; then
    echo No nix found. Installing...
    mkdir -p -m 0755 /nix
    groupadd nixbld -g 30000 || true
    for i in {1..10}; do
        useradd -c "Nix build user $i" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" "nixbld$i" || true
    done
    sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-channel-add
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

fnix () {
    nix --experimental-features "nix-command flakes" $@
}

SYSTEM=$(fnix build github:kagari-network/flakes#minimal-system --print-out-paths --no-link)

nix-env -p /nix/var/nix/profiles/kagari --set "$SYSTEM"