#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/docs/book/images"
BIN="${TMPDIR:-/tmp}/crystal-qt6-dialog-gallery"
APP_NAME="$(basename "$BIN")"
PYTHON="${PYTHON:-/tmp/crystal-qt6-screenshot-venv/bin/python}"
SCREENSHOT_REGION="${SCREENSHOT_REGION:-80,40,980,760}"
USE_WINDOW_IDS=1

if ! "$PYTHON" -c "import Quartz" >/dev/null 2>&1; then
  USE_WINDOW_IDS=0
fi

mkdir -p "$OUT"
crystal build "$ROOT/examples/dialog_gallery.cr" -o "$BIN"

find_window_id() {
  local pid="$1"
  local pattern="$2"
  local any_pid="${3:-0}"

  "$PYTHON" - "$pid" "$pattern" "$any_pid" <<'PY'
import re
import sys

import Quartz

pid = int(sys.argv[1])
pattern = sys.argv[2]
any_pid = sys.argv[3] == "1"
regex = re.compile(pattern, re.IGNORECASE) if pattern else None

windows = Quartz.CGWindowListCopyWindowInfo(
    Quartz.kCGWindowListOptionOnScreenOnly,
    Quartz.kCGNullWindowID,
) or []

candidates = []
same_process_dialogs = []
for index, window in enumerate(windows):
    name = str(window.get("kCGWindowName", "") or "")
    owner = str(window.get("kCGWindowOwnerName", "") or "")
    owner_pid = int(window.get("kCGWindowOwnerPID", 0) or 0)
    layer = int(window.get("kCGWindowLayer", 0) or 0)
    bounds = window.get("kCGWindowBounds", {}) or {}
    width = float(bounds.get("Width", 0) or 0)
    height = float(bounds.get("Height", 0) or 0)

    if layer != 0 or width < 120 or height < 80:
        continue
    if not any_pid and owner_pid != pid:
        continue

    text = f"{name} {owner}"
    if regex and not regex.search(text):
        if owner_pid == pid and name != "Dialog Gallery":
            same_process_dialogs.append((index, width * height, window))
        continue

    candidates.append((index, width * height, window))

if not candidates and not any_pid and same_process_dialogs:
    candidates = same_process_dialogs

if not candidates:
    sys.exit(1)

candidates.sort(key=lambda item: item[0])
print(candidates[0][2]["kCGWindowNumber"])
PY
}

capture_dialog() {
  local label="$1"
  local auto_name="$2"
  local pattern="$3"
  local filename="$4"
  local delay="${5:-1.4}"
  local any_pid="${6:-0}"
  local pid
  local watcher_pid
  local app_status
  local watcher_status

  echo "Capturing $filename"

  if [[ "$USE_WINDOW_IDS" == "1" ]]; then
    "$PYTHON" - "$pattern" "$any_pid" "$OUT/$filename" "$APP_NAME" "$SCREENSHOT_REGION" "$delay" <<'PY' &
import os
import re
import signal
import subprocess
import sys
import time

import Quartz

pattern = sys.argv[1]
any_pid = sys.argv[2] == "1"
out = sys.argv[3]
app_name = sys.argv[4]
region = sys.argv[5]
delay = float(sys.argv[6])
regex = re.compile(pattern, re.IGNORECASE) if pattern else None
main_pid = None

def visible_windows():
    windows = Quartz.CGWindowListCopyWindowInfo(
        Quartz.kCGWindowListOptionOnScreenOnly,
        Quartz.kCGNullWindowID,
    ) or []

    for index, window in enumerate(windows):
        name = str(window.get("kCGWindowName", "") or "")
        owner = str(window.get("kCGWindowOwnerName", "") or "")
        owner_pid = int(window.get("kCGWindowOwnerPID", 0) or 0)
        layer = int(window.get("kCGWindowLayer", 0) or 0)
        bounds = window.get("kCGWindowBounds", {}) or {}
        width = float(bounds.get("Width", 0) or 0)
        height = float(bounds.get("Height", 0) or 0)

        if layer != 0 or width < 120 or height < 80:
            continue

        yield index, name, owner, owner_pid, width, height, window

def capture_window(window):
    window_id = str(window["kCGWindowNumber"])
    time.sleep(0.25)
    subprocess.run(["screencapture", "-x", "-l", window_id, out], check=True)

def terminate(pid):
    if pid:
        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            pass

deadline = time.monotonic() + 30
time.sleep(1.2)
while time.monotonic() < deadline:
    candidates = []
    fallback_candidates = []

    for index, name, owner, owner_pid, width, height, window in visible_windows():
        if owner == app_name and name == "Dialog Gallery":
            main_pid = owner_pid

        if not any_pid and owner != app_name:
            continue

        text = f"{name} {owner}"
        if regex and regex.search(text):
            candidates.append((index, width * height, owner_pid, window))
        elif owner == app_name and name != "Dialog Gallery":
            fallback_candidates.append((index, width * height, owner_pid, window))

    if not candidates and not any_pid and fallback_candidates:
        candidates = fallback_candidates

    if candidates:
        candidates.sort(key=lambda item: item[0])
        _, _, owner_pid, window = candidates[0]
        capture_window(window)
        terminate(owner_pid)
        sys.exit(0)

    time.sleep(0.25)

time.sleep(delay)
subprocess.run(["screencapture", "-x", "-R", region, out], check=True)
terminate(main_pid)
sys.exit(1)
PY
    watcher_pid="$!"

    set +e
    "$BIN" "--auto=$auto_name"
    app_status="$?"
    set -e

    set +e
    wait "$watcher_pid"
    watcher_status="$?"
    set -e

    if [[ "$watcher_status" == "0" ]]; then
        echo "Captured $label"
        return 0
    fi

    echo "Window lookup failed for $label; using region fallback" >&2
    echo "Captured $label"
    return 0
  fi

  "$BIN" "--auto=$auto_name" &
  pid="$!"
  sleep "$delay"
  screencapture -x -R "$SCREENSHOT_REGION" "$OUT/$filename"
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  echo "Captured $label"
}

capture_dialog "gallery" "main" "Dialog Gallery" "dialogs-main-window.png" 1.0
capture_dialog "message question" "message-question" "Save Changes" "dialogs-message-question.png" 1.3
capture_dialog "message warning" "message-warning" "Layer Warning" "dialogs-message-warning.png" 1.3
capture_dialog "file open" "file-open" "Open Example File|Open" "dialogs-file-open.png" 1.8
capture_dialog "file save" "file-save" "Save Example File|Save" "dialogs-file-save.png" 1.8
capture_dialog "color dialog" "color-dialog" "Pick Layer Color|Colors" "dialogs-color-dialog.png" 2.0 1
capture_dialog "color alpha" "color-alpha" "Pick Accent Color|Colors" "dialogs-color-alpha.png" 2.0 1
capture_dialog "font dialog" "font-dialog" "Choose Label Font|Fonts" "dialogs-font-dialog.png" 2.0 1
capture_dialog "font monospaced" "font-monospaced" "Choose Code Font|Fonts" "dialogs-font-monospaced.png" 2.0 1
capture_dialog "input text" "input-text" "Rename Layer" "dialogs-input-text.png" 1.3
capture_dialog "input int" "input-int" "Layer Opacity" "dialogs-input-int.png" 1.3
capture_dialog "input choice" "input-choice" "Layer Kind" "dialogs-input-choice.png" 1.3
capture_dialog "progress" "progress-dialog" "ProgressDialog|Generating preview assets" "dialogs-progress-dialog.png" 1.0
capture_dialog "progress canceled" "progress-canceled" "ProgressDialog|Generating preview assets" "dialogs-progress-canceled.png" 1.0
capture_dialog "custom settings" "custom-settings" "Layer Settings" "dialogs-custom-settings.png" 1.3
