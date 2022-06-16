#!/usr/bin/env bash
set -e

# check groupadd useradd curl git

if ! command -v nix; then
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

TMP=$(mktemp -d)
git clone https://github.com/kagari-network/flakes.git $TMP

cd $TMP
SYSTEM=$(fnix build .#minimal-system --print-out-paths --no-link)

nix-env -p /nix/var/nix/profiles/kagari --set "$SYSTEM"