#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$MODULE_DIR/.." && pwd -P)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/mako/config"

source "$ROOT_DIR/setup/lib.sh"

case "${1:-enable}" in
  enable)
    # Link only the config file, preserving other files in the mako directory.
    link_path "$MODULE_DIR/config" "$DEST"
    info "Apply to a running daemon with: makoctl reload"
    ;;
  disable)
    unlink_path "$MODULE_DIR/config" "$DEST"
    ;;
  *)
    error "Usage: bash $MODULE_DIR/setup.sh [enable|disable]"
    exit 2
    ;;
esac
