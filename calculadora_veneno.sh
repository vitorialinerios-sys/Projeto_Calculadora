#!/bin/bash

# ============================================================
# CALCULADORA DE RENDIMENTO DE VENENO
# Script principal da calculadora
# ============================================================

# ============================================================
# DIRETÓRIOS E ARQUIVOS
# ============================================================

BASE_DIR="/home/vitoria/atividades/calculadora_veneno"

DADOS_DIR="$BASE_DIR/dados"
CSV_FILE_PATH="$DADOS_DIR/registros_diarios.csv"

# Cria a pasta caso ela não exista
mkdir -p "$DADOS_DIR"


# ============================================================
# CRIAÇÃO DO ARQUIVO CSV
# ============================================================

if [ ! -f "$CSV_FILE_PATH" ]; then
    echo "id_registro,data_registro,especie,veneno_manha_g,extraidas_manha,media_manha_mg,veneno_tarde_g,extraidas_tarde,media_tarde_mg,media_dia_mg,media_padrao_mg" \
        > "$CSV_FILE_PATH"
fi


# ============================================================
# FUNÇÕES DE VALIDAÇÃO
# ============================================================

obter_especie_valida() {
    while true; do
        echo ""
        echo "Espécies disponíveis:"
        echo "L. gaucho"
        echo "L. intermedia"
        echo "L. laeta"

        read -r -p "Digite a espécie: " especie

        case "$especie" in
            "L. gaucho")
                MEDIA_PADRAO="0.40"
                return
                ;;

            "L. intermedia")
                MEDIA_PADRAO="0.33"
                return
                ;;

            "L. laeta")
                MEDIA_PADRAO="0.48"
                return
                ;;

            *)
                echo "Espécie inválida. Tente novamente."
                ;;
        esac
    done
}


obter_float_valido() {
    local prompt="$1"

    while true; do
        read -r -p "$prompt" valor

        # Permite o uso de vírgula ou ponto
        valor="${valor//,/.}"

        if [[ "$valor" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            echo "$valor"
            return
        else
            echo "Entrada inválida. Digite um número, por exemplo: 0.1102" >&2
        fi
    done
}


obter_inteiro_valido() {
    local prompt="$1"

    while true; do
        read -r -p "$prompt" valor

        if [[ "$valor" =~ ^[1-9][0-9]*$ ]]; then
            echo "$valor"
            return
        else
            echo "Entrada inválida. Digite um número inteiro maior que zero." >&2
        fi
    done
}


# ============================================================
# FUNÇÕES DE CÁLCULO
# ============================================================

calcular_media() {
    local veneno="$1"
    local quantidade="$2"

    awk \
        -v veneno="$veneno" \
        -v quantidade="$quantidade" '
        BEGIN {
            # Primeiro calcula a média em gramas
            media_gramas = veneno / quantidade

            # Depois converte a média para miligramas
            media_miligramas = media_gramas * 1000

            printf "%.3f", media_miligramas
        }
    '
}


calcular_media_dia() {
    local veneno_manha="$1"
    local extraidas_manha="$2"
    local veneno_tarde="$3"
    local extraidas_tarde="$4"

    awk \
        -v veneno_manha="$veneno_manha" \
        -v extraidas_manha="$extraidas_manha" \
        -v veneno_tarde="$veneno_tarde" \
        -v extraidas_tarde="$extraidas_tarde" '
        BEGIN {
            veneno_total = veneno_manha + veneno_tarde
            aranhas_total = extraidas_manha + extraidas_tarde

            # Média total em gramas por aranha
            media_dia_gramas = veneno_total / aranhas_total

            # Conversão da média para miligramas
            media_dia_miligramas = media_dia_gramas * 1000

            printf "%.3f", media_dia_miligramas
        }
    '
}


# ============================================================
# COMPARAÇÃO COM A MÉDIA PADRÃO
# ============================================================

atingiu_media() {
    local media="$1"
    local padrao="$2"

    awk \
        -v media="$media" \
        -v padrao="$padrao" '
        BEGIN {
            if (media >= padrao) {
                exit 0
            } else {
                exit 1
            }
        }
    '
}


# ============================================================
# IMPRESSÃO DOS RESULTADOS
# ============================================================

imprimir_resultados() {
    local especie="$1"
    local media_manha="$2"
    local media_tarde="$3"
    local media_dia="$4"
    local media_padrao="$5"

    echo ""
    echo "========== RESULTADOS =========="
    echo "Espécie: $especie"
    echo "Média padrão: $media_padrao mg"
    echo ""

    echo "Média da equipe da manhã: $media_manha mg"

    if atingiu_media "$media_manha" "$media_padrao"; then
        echo "Equipe da manhã atingiu a média padrão."
    else
        echo "Equipe da manhã não atingiu a média padrão."
    fi

    echo ""
    echo "Média da equipe da tarde: $media_tarde mg"

    if atingiu_media "$media_tarde" "$media_padrao"; then
        echo "Equipe da tarde atingiu a média padrão."
    else
        echo "Equipe da tarde não atingiu a média padrão."
    fi

    echo ""
    echo "Média do dia: $media_dia mg"

    if atingiu_media "$media_dia" "$media_padrao"; then
        echo "As equipes atingiram a média padrão."
    else
        echo "As equipes não atingiram a média padrão."
    fi

    echo "================================"
}


# ============================================================
# ATUALIZAÇÃO DOS DADOS DA TARDE NO CSV
# ============================================================

atualizar_registro_tarde() {
    local id="$1"
    local veneno_tarde="$2"
    local extraidas_tarde="$3"
    local media_tarde="$4"
    local media_dia="$5"

    arquivo_temporario="${CSV_FILE_PATH}.tmp"

    awk \
        -F',' \
        -v OFS=',' \
        -v id="$id" \
        -v veneno_tarde="$veneno_tarde" \
        -v extraidas_tarde="$extraidas_tarde" \
        -v media_tarde="$media_tarde" \
        -v media_dia="$media_dia" '
        NR == 1 {
            print
            next
        }

        $1 == id {
            $7 = veneno_tarde
            $8 = extraidas_tarde
            $9 = media_tarde
            $10 = media_dia
        }

        {
            print
        }
    ' "$CSV_FILE_PATH" > "$arquivo_temporario"

    mv "$arquivo_temporario" "$CSV_FILE_PATH"
}


# ============================================================
# PROGRAMA PRINCIPAL
# ============================================================

while true; do

    REGISTRO_ID=$(date +"%Y%m%d%H%M%S%N")
    DATA_REGISTRO=$(date +"%Y-%m-%d %H:%M:%S")

    echo ""
    echo "=============================================="
    echo "NOVO REGISTRO DO DIA"
    echo "ID: $REGISTRO_ID"
    echo "=============================================="

    # --------------------------------------------------------
    # ESPÉCIE
    # --------------------------------------------------------

    obter_especie_valida

    ESPECIE="$especie"

    # --------------------------------------------------------
    # DADOS DA MANHÃ
    # --------------------------------------------------------

    echo ""
    echo "--- Dados da manhã ---"

    VENENO_MANHA=$(obter_float_valido \
        "Veneno produzido pela manhã (g): ")

    EXTRAIDAS_MANHA=$(obter_inteiro_valido \
        "Quantidade de aranhas extraídas pela manhã: ")

    MEDIA_MANHA=$(calcular_media \
        "$VENENO_MANHA" \
        "$EXTRAIDAS_MANHA")

    echo ""
    echo "Média da manhã: $MEDIA_MANHA mg"

    # Salva o registro parcial da manhã
    printf "%s,%s,%s,%s,%s,%s,,,,,%s\n" \
        "$REGISTRO_ID" \
        "$DATA_REGISTRO" \
        "$ESPECIE" \
        "$VENENO_MANHA" \
        "$EXTRAIDAS_MANHA" \
        "$MEDIA_MANHA" \
        "$MEDIA_PADRAO" \
        >> "$CSV_FILE_PATH"

    echo "Dados da manhã registrados com sucesso."


    # --------------------------------------------------------
    # DADOS DA TARDE
    # --------------------------------------------------------

    echo ""
    echo "--- Dados da tarde ---"

    VENENO_TARDE=$(obter_float_valido \
        "Veneno produzido pela tarde (g): ")

    EXTRAIDAS_TARDE=$(obter_inteiro_valido \
        "Quantidade de aranhas extraídas pela tarde: ")

    MEDIA_TARDE=$(calcular_media \
        "$VENENO_TARDE" \
        "$EXTRAIDAS_TARDE")

    MEDIA_DIA=$(calcular_media_dia \
        "$VENENO_MANHA" \
        "$EXTRAIDAS_MANHA" \
        "$VENENO_TARDE" \
        "$EXTRAIDAS_TARDE")

    atualizar_registro_tarde \
        "$REGISTRO_ID" \
        "$VENENO_TARDE" \
        "$EXTRAIDAS_TARDE" \
        "$MEDIA_TARDE" \
        "$MEDIA_DIA"

    echo ""
    echo "Dados da tarde registrados com sucesso."
    echo "Média da tarde: $MEDIA_TARDE mg"
    echo "Média do dia: $MEDIA_DIA mg"

    imprimir_resultados \
        "$ESPECIE" \
        "$MEDIA_MANHA" \
        "$MEDIA_TARDE" \
        "$MEDIA_DIA" \
        "$MEDIA_PADRAO"

    echo ""
    read -r -p "Deseja cadastrar outro dia? (s/n): " CONTINUAR

    if [[ "${CONTINUAR,,}" != "s" ]]; then
        break
    fi

done


# ============================================================
# FINALIZAÇÃO
# ============================================================

echo ""
echo "=============================================="
echo "Registros salvos no arquivo:"
echo "$CSV_FILE_PATH"
echo "=============================================="
