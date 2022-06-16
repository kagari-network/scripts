#!/usr/bin/env bash
set -e

KAGARI=/nix/var/nix/profiles/kagari
NSPAWN=$KAGARI/systemd/bin/systemd-nspawn
INIT=$KAGARI/init

if [ ! -f $KAGARI ]; then
    echo please install kagari before running.
    exit 1
fi

$NSPAWN -D /var/empty -x --bind /nix/nix $INIT