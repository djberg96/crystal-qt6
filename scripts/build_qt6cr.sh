#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

QT_PKG=${QT_PKG:-Qt6Widgets}
PKG_CONFIG=${PKG_CONFIG:-pkg-config}
CXX=${CXX:-c++}
AR=${AR:-ar}

BUILD_DIR=$ROOT_DIR/ext/qt6cr/build
INCLUDE_DIR=$ROOT_DIR/ext/qt6cr/include
SRC=$ROOT_DIR/ext/qt6cr/src/qt6cr.cpp
HEADER=$INCLUDE_DIR/qt6cr.h
OBJ=$BUILD_DIR/qt6cr.o
LIB=$BUILD_DIR/libqt6cr.a

if ! command -v "$PKG_CONFIG" >/dev/null 2>&1; then
  echo "qt6cr: missing required tool '$PKG_CONFIG'" >&2
  exit 1
fi

if ! command -v "$CXX" >/dev/null 2>&1; then
  echo "qt6cr: missing required C++ compiler '$CXX'" >&2
  exit 1
fi

if ! command -v "$AR" >/dev/null 2>&1; then
  echo "qt6cr: missing required archiver '$AR'" >&2
  exit 1
fi

if ! "$PKG_CONFIG" --exists "$QT_PKG"; then
  echo "qt6cr: pkg-config could not find '$QT_PKG'; install the Qt6 Widgets development package" >&2
  exit 1
fi

mkdir -p "$BUILD_DIR"

if [ -f "$LIB" ] && [ -f "$OBJ" ] && [ "$OBJ" -nt "$SRC" ] && [ "$OBJ" -nt "$HEADER" ]; then
  exit 0
fi

"$CXX" -std=c++17 -fPIC -I"$INCLUDE_DIR" $("$PKG_CONFIG" --cflags "$QT_PKG") ${CXXFLAGS:-} -c "$SRC" -o "$OBJ"
rm -f "$LIB"
"$AR" rcs "$LIB" "$OBJ"
