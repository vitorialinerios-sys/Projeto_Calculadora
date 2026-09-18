#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

DADOS_DIR="$BASE_DIR/dados"
RELATORIOS_DIR="$BASE_DIR/relatorios"

CSV_FILE_PATH="$DADOS_DIR/registros_diarios.csv"

DATA_ATUAL=$(date +"%Y-%m-%d")
GRAFICO_FILE="$RELATORIOS_DIR/grafico_rendimento_${DATA_ATUAL}.png"

mkdir -p "$RELATORIOS_DIR"

if [ ! -f "$CSV_FILE_PATH" ]; then
    echo "Erro: arquivo CSV não encontrado:"
    echo "$CSV_FILE_PATH"
    exit 1
fi

if ! command -v gnuplot > /dev/null 2>&1; then
    echo "Erro: o gnuplot não está instalado."
    exit 1
fi

gnuplot <<EOF
set terminal pngcairo size 1200,700
set output "$GRAFICO_FILE"

set datafile separator ","

set title "Rendimento de Veneno por Registro"
set xlabel "Data do registro"
set ylabel "Média de veneno (mg)"

set grid
set key outside

set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d/%m/%Y\n%H:%M"

set xtics rotate by -45

plot \
    "$CSV_FILE_PATH" every ::1 using 2:6 with linespoints linewidth 2 pointtype 7 title "Média da manhã", \
    "$CSV_FILE_PATH" every ::1 using 2:9 with linespoints linewidth 2 pointtype 5 title "Média da tarde", \
    "$CSV_FILE_PATH" every ::1 using 2:10 with linespoints linewidth 2 pointtype 9 title "Média do dia", \
    "$CSV_FILE_PATH" every ::1 using 2:11 with lines linewidth 2 dashtype 2 title "Média padrão"
EOF

if [ $? -eq 0 ]; then
    echo "Gráfico gerado com sucesso."
    echo "Arquivo:"
    echo "$GRAFICO_FILE"
else
    echo "Erro ao gerar o gráfico."
    exit 1
fi
