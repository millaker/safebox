#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
START_MARKER="# >>> safebox initialize >>>"
END_MARKER="# <<< safebox initialize <<<"

detect_rc_file() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"

  case "${shell_name}" in
    zsh)
      echo "${HOME}/.zshrc"
      ;;
    bash)
      echo "${HOME}/.bashrc"
      ;;
    *)
      echo "Error: Unsupported or unrecognized shell '${shell_name}'" >&2
      exit 1
      ;;
  esac
}

remove_block() {
  local rc_file="$1"
  if [ ! -f "${rc_file}" ]; then
    return 0
  fi

  local tmp_file
  tmp_file="$(mktemp "${TMPDIR:-/tmp}/safebox_rc.XXXXXX")"

  awk -v start="${START_MARKER}" -v end="${END_MARKER}" '
    $0 == start { skipping = 1; next }
    $0 == end { skipping = 0; next }
    !skipping { print }
  ' "${rc_file}" > "${tmp_file}"

  mv "${tmp_file}" "${rc_file}"
}

do_uninstall() {
  local rc_file
  rc_file="$(detect_rc_file)"

  if [ -f "${rc_file}" ] && grep -qF "${START_MARKER}" "${rc_file}"; then
    remove_block "${rc_file}"
    echo "Removed safebox configuration from ${rc_file}."
    echo "Please restart your shell or run: source ${rc_file}"
  else
    echo "safebox is not configured in ${rc_file}."
  fi
}

do_install() {
  local rc_file
  rc_file="$(detect_rc_file)"

  # Ensure target rc file exists
  if [ ! -f "${rc_file}" ]; then
    touch "${rc_file}"
  fi

  # Ensure safebox is executable
  chmod +x "${SCRIPT_DIR}/safebox"

  remove_block "${rc_file}"

  # Append new configuration block
  {
    # Ensure there is a newline before adding the block if the file is not empty
    if [ -s "${rc_file}" ] && [ "$(tail -c 1 "${rc_file}" | wc -l)" -eq 0 ]; then
      echo ""
    fi
    echo "${START_MARKER}"
    echo "export PATH=\"${SCRIPT_DIR}:\$PATH\""
    echo "${END_MARKER}"
  } >> "${rc_file}"

  echo "Successfully installed safebox!"
  echo "Added ${SCRIPT_DIR} to PATH in ${rc_file}."
  echo ""
  echo "To start using 'safebox' immediately, run:"
  echo "  source \"${rc_file}\""
  echo ""
  echo "Or open a new terminal window."
}

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -u, --uninstall    Remove safebox configuration from your shell rc file"
  echo "  -h, --help         Show this help message"
  exit 0
}

case "${1:-}" in
  -u|--uninstall)
    do_uninstall
    ;;
  -h|--help)
    usage
    ;;
  "")
    do_install
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    ;;
esac
