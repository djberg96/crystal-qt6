#!/usr/bin/env bash
set -euo pipefail

use_xvfb=1
if [ "${1:-}" = "--no-xvfb" ]; then
  use_xvfb=0
  shift
fi

if [ "$#" -eq 0 ]; then
  set -- crystal spec
fi

os_name="$(uname -s)"

case "$os_name" in
Linux)
  QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb}"
  export QT_QPA_PLATFORM

  if [ "$use_xvfb" = "1" ] && [ "$QT_QPA_PLATFORM" = "xcb" ] && [ -z "${DISPLAY:-}" ]; then
    if command -v xvfb-run >/dev/null 2>&1; then
      exec xvfb-run -a -s "-screen 0 1280x1024x24" "$0" --no-xvfb "$@"
    fi

    echo "warning: DISPLAY is unset and xvfb-run was not found; running GUI specs without Xvfb" >&2
  fi
  ;;
Darwin)
  QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-offscreen}"
  export QT_QPA_PLATFORM
  ;;
*)
  QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-offscreen}"
  export QT_QPA_PLATFORM
  ;;
esac

if [ -z "${CRYSTAL_CACHE_DIR:-}" ]; then
  CRYSTAL_CACHE_DIR="${TMPDIR:-/tmp}/crystal-qt6-cache"
  export CRYSTAL_CACHE_DIR
fi

QT_QUICK_BACKEND="${QT_QUICK_BACKEND:-software}"
export QT_QUICK_BACKEND

QT_LOGGING_RULES="${QT_LOGGING_RULES:-qt.qpa.fonts=false}"
export QT_LOGGING_RULES

echo "GUI spec runner: os=$os_name platform=$QT_QPA_PLATFORM display=${DISPLAY:-none}"

filter_qpa_warnings="${QT6CR_FILTER_QPA_WARNINGS:-}"
if [ -z "$filter_qpa_warnings" ]; then
  filter_qpa_warnings=0
  if [ "$os_name" = "Darwin" ] && [ "$QT_QPA_PLATFORM" = "offscreen" ]; then
    filter_qpa_warnings=1
  fi
fi

if [ "$filter_qpa_warnings" = "1" ]; then
  set +e
  "$@" 2>&1 | awk '{ gsub(/This plugin does not support propagateSizeHints\(\)/, ""); if ($0 != "") print }'
  status=${PIPESTATUS[0]}
  set -e
  exit "$status"
fi

exec "$@"
