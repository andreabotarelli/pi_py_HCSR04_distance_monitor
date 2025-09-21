#!/usr/bin/env bash
# project_setup.sh
# Deve essere salvato ed eseguito (con `source`) nella cartella del progetto.

set -euo pipefail

# --- Guard 1: deve essere "sourced" per poter attivare il venv nella shell corrente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "ERRORE: esegui questo script con:"
  echo "  source ./project_setup.sh"
  return 1 2>/dev/null || exit 1
fi

# --- Guard 2: deve essere eseguito dalla cartella in cui risiede lo script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
  echo "ERRORE: devi lanciare lo script dalla sua cartella:"
  echo "  cd \"$SCRIPT_DIR\" && source ./$(basename "${BASH_SOURCE[0]}")"
  return 1
fi

echo "[1/4] Installo pigpio e avvio il demone..."
if ! command -v apt >/dev/null 2>&1; then
  echo "ERRORE: questo setup richiede un sistema con 'apt' (Debian/Raspberry Pi OS)." >&2
  return 1
fi
sudo apt update
sudo apt install -y pigpio python3-venv
sudo systemctl enable --now pigpiod

echo "[2/4] Creo (se serve) il virtualenv in .venv..."
VENV_DIR=".venv"
if [[ ! -d "$VENV_DIR" ]]; then
  python3 -m venv "$VENV_DIR"
else
  echo "  .venv esiste già: lo riutilizzo."
fi

echo "[3/4] Attivo il venv e installo i requisiti..."
# Attiva il venv nella shell chiamante (persiste perché lo script è sourced)
source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip

REQ_FILE="requirements.txt"
if [[ -f "$REQ_FILE" ]]; then
  pip install -r "$REQ_FILE"
else
  echo "ATTENZIONE: $REQ_FILE non trovato; salto l'installazione dei requisiti." >&2
fi

echo "[4/4] Venv attivo in questa shell."
echo "Pronto! pigpio è avviato e l'ambiente è attivo (python: $(python -V))."
