#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

function run {
  nix-shell --pure --argstr run "$*" "$ROOT/env.nix"
}

if [[ $# -eq 0 ]]; then
  run bash
else
  run "$@"
fi
