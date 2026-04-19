#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${1:-$HOME/.local/bin}"
DEST_NAME="${2:-ffuf-bonito}"
DEST_PATH="${DEST_DIR}/${DEST_NAME}"
REPO_RAW_BASE="https://raw.githubusercontent.com/Jugolino/FFUF_BONITO/main"

resolve_source() {
  if [[ -f "${SCRIPT_DIR}/ffuf" ]]; then
    printf '%s\n' "${SCRIPT_DIR}/ffuf"
    return
  fi

  if [[ -f "${SCRIPT_DIR}/script" ]]; then
    printf '%s\n' "${SCRIPT_DIR}/script"
    return
  fi

  printf '%s\n' ""
}

download_source() {
  local tmp_file="$1"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${REPO_RAW_BASE}/script" -o "${tmp_file}"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO "${tmp_file}" "${REPO_RAW_BASE}/script"
    return
  fi

  echo "[erro] curl ou wget nao encontrado para baixar o script" >&2
  exit 1
}

SOURCE_SCRIPT="$(resolve_source)"

if [[ -z "${SOURCE_SCRIPT}" ]]; then
  TMP_FILE="$(mktemp)"
  trap 'rm -f "${TMP_FILE}"' EXIT
  echo "[info] script local nao encontrado, baixando do GitHub..."
  download_source "${TMP_FILE}"
  SOURCE_SCRIPT="${TMP_FILE}"
fi

mkdir -p "${DEST_DIR}"
cp "${SOURCE_SCRIPT}" "${DEST_PATH}"
chmod +x "${DEST_PATH}"

echo "[ok] instalado em: ${DEST_PATH}"

case ":${PATH}:" in
  *":${DEST_DIR}:"*)
    echo "[ok] ${DEST_DIR} ja esta no PATH"
    ;;
  *)
    echo "[info] adicione ao PATH se quiser usar de qualquer lugar:"
    echo "export PATH=\"${DEST_DIR}:\$PATH\""
    ;;
esac

echo
echo "Uso:"
echo "  ${DEST_NAME} https://example.com /caminho/wordlist.txt"
