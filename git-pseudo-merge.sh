#!/bin/bash

# Git pseudo-merge: checkout branch1 and overlay files from branch2
# Only updates files that exist in both branches

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <branch1> <branch2>" >&2
    echo "  Checks out branch1 and overlays matching files from branch2" >&2
    exit 1
fi

branch1="$1"
branch2="$2"

# Checkout branch1
git checkout "$branch1" || exit 1

# Overlay files from branch2 that exist in current working tree
git ls-tree -r --name-only "$branch2" | xargs -r -I {} bash -c '[[ -e "{}" ]] && git checkout "'"$branch2"'" -- "{}"'

echo "Pseudo-merge complete: $branch1 with files from $branch2"
