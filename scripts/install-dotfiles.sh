#!/bin/sh

# set -e

CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_DIR="$(dirname "$CURRENT_DIR")"
BASE_NAME="$(basename $BASE_DIR)"

# TARGET=/tmp/dotfile-home
TARGET=$HOME

cp -r $BASE_DIR/dotfiles/. $TARGET/
