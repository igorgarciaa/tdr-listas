#!/usr/bin/env bash
set -euo pipefail

# Recusa a rodar sem os dois argumentos
if [[ $# -ne 2 ]]; then
    echo "Uso: $(basename "$0") <arquivo.csv> <numero-da-coluna>" >&2
    exit 1
fi

arquivo="$1"
coluna="$2"
mes=5   # posicao da coluna Month, conferida com cat -n

# Nome da coluna, lido do cabecalho do proprio arquivo
nome=$(head -n 1 "$arquivo" | cut -d, -f"$coluna")

# Numero de observacoes: linhas menos o cabecalho
n_obs=$(($(wc -l < "$arquivo") - 1))

# Quantidade de NA na coluna escolhida
n_na=$(tail -n +2 "$arquivo" | cut -d, -f"$coluna" | grep -c '^NA$' || true)

printf 'Variavel: %s\n' "$nome"
printf 'Observacoes: %d\n' "$n_obs"
printf 'Valores NA: %d\n\n' "$n_na"

printf 'Mes Media Dias\n'
awk -F, -v c="$coluna" -v m="$mes" '
    NR > 1 && $c != "NA" && $c != "" { soma[$m] += $c; n[$m]++ }
    END { for (k in soma) printf "%s %.2f %d\n", k, soma[k] / n[k], n[k] }
' "$arquivo" | sort -n
