#!/bin/bash

# ============================================================
# Tarefa 7.2 - Variável que representa o diretório dos relatórios
# ============================================================

RELATORIOS_DIR="/home/vitoria/atividades/calculadora_veneno/relatorios"

# Garante que o diretório exista
mkdir -p "$RELATORIOS_DIR"


# ============================================================
# Tarefa 7.3 - Variável que representa a data atual
# ============================================================

DATA_ATUAL=$(date +"%Y-%m-%d")


# ============================================================
# Caminho do script da calculadora
# ============================================================

CALCULADORA="/home/vitoria/atividades/calculadora_veneno/script/calculadora_veneno.sh"


# ============================================================
# Tarefa 7.5 - Nome do relatório contendo a data
# ============================================================

ARQUIVO_RELATORIO="$RELATORIOS_DIR/relatorio_${DATA_ATUAL}.txt"


# ============================================================
# Tarefa 7.4 - Executa a calculadora
# Tarefa 7.5 - Direciona a saída para o relatório
# ============================================================

{
    echo "=============================================="
    echo "RELATÓRIO DA CALCULADORA DE VENENO"
    echo "Data: $DATA_ATUAL"
    echo "=============================================="
    echo ""

    bash "$CALCULADORA"

} 2>&1 | tee "$ARQUIVO_RELATORIO"


# ============================================================
# Tarefa 7.6 - Informa o caminho do relatório gerado
# ============================================================

echo ""
echo "=============================================="
echo "Relatório gerado com sucesso."
echo "Caminho do relatório:"
echo "$ARQUIVO_RELATORIO"
echo "=============================================="
