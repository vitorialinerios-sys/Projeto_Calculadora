from pathlib import Path
from datetime import datetime
import csv
import os
import tempfile


# ============================================================
# DIRETÓRIOS E ARQUIVOS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent
DADOS_DIR = BASE_DIR / "dados"
CSV_FILE_PATH = DADOS_DIR / "registros_diarios.csv"

DADOS_DIR.mkdir(parents=True, exist_ok=True)

CABECALHO = [
    "id_registro",
    "data_registro",
    "especie",
    "veneno_manha_g",
    "extraidas_manha",
    "media_manha_mg",
    "veneno_tarde_g",
    "extraidas_tarde",
    "media_tarde_mg",
    "media_dia_mg",
    "media_padrao_mg",
]


# ============================================================
# CRIAÇÃO DO ARQUIVO CSV
# ============================================================

def criar_csv_se_necessario():
    if not CSV_FILE_PATH.exists():
        with open(CSV_FILE_PATH, "w", newline="", encoding="utf-8") as arquivo:
            escritor = csv.writer(arquivo)
            escritor.writerow(CABECALHO)


# ============================================================
# FUNÇÕES DE VALIDAÇÃO
# ============================================================

def obter_especie_valida():
    especies = {
        "L. gaucho": 0.40,
        "L. intermedia": 0.33,
        "L. laeta": 0.48,
    }

    while True:
        print("\nEspécies disponíveis:")
        print("L. gaucho")
        print("L. intermedia")
        print("L. laeta")

        especie = input("Digite a espécie: ").strip()

        if especie in especies:
            return especie, especies[especie]

        print("Espécie inválida. Tente novamente.")


def obter_float_valido(prompt):
    while True:
        valor = input(prompt).strip().replace(",", ".")

        try:
            numero = float(valor)

            if numero >= 0:
                return numero

            print("Digite um número maior ou igual a zero.")

        except ValueError:
            print("Entrada inválida. Digite um número, por exemplo: 0.1102")


def obter_inteiro_valido(prompt):
    while True:
        valor = input(prompt).strip()

        try:
            numero = int(valor)

            if numero > 0:
                return numero

            print("Digite um número inteiro maior que zero.")

        except ValueError:
            print("Entrada inválida. Digite um número inteiro maior que zero.")


# ============================================================
# FUNÇÕES DE CÁLCULO
# ============================================================

def calcular_media(veneno, quantidade):
    """
    Recebe o veneno em gramas e a quantidade de aranhas.
    Retorna a média em miligramas.
    """
    media_gramas = veneno / quantidade
    media_miligramas = media_gramas * 1000

    return round(media_miligramas, 3)


def calcular_media_dia(
    veneno_manha,
    extraidas_manha,
    veneno_tarde,
    extraidas_tarde,
):
    veneno_total = veneno_manha + veneno_tarde
    aranhas_total = extraidas_manha + extraidas_tarde

    media_dia_gramas = veneno_total / aranhas_total
    media_dia_miligramas = media_dia_gramas * 1000

    return round(media_dia_miligramas, 3)


# ============================================================
# COMPARAÇÃO COM A MÉDIA PADRÃO
# ============================================================

def atingiu_media(media, padrao):
    return media >= padrao


# ============================================================
# IMPRESSÃO DOS RESULTADOS
# ============================================================

def imprimir_resultados(
    especie,
    media_manha,
    media_tarde,
    media_dia,
    media_padrao,
):
    print("\n========== RESULTADOS ==========")
    print(f"Espécie: {especie}")
    print(f"Média padrão: {media_padrao:.2f} mg")
    print()

    print(f"Média da equipe da manhã: {media_manha:.3f} mg")

    if atingiu_media(media_manha, media_padrao):
        print("Equipe da manhã atingiu a média padrão.")
    else:
        print("Equipe da manhã não atingiu a média padrão.")

    print()
    print(f"Média da equipe da tarde: {media_tarde:.3f} mg")

    if atingiu_media(media_tarde, media_padrao):
        print("Equipe da tarde atingiu a média padrão.")
    else:
        print("Equipe da tarde não atingiu a média padrão.")

    print()
    print(f"Média do dia: {media_dia:.3f} mg")

    if atingiu_media(media_dia, media_padrao):
        print("As equipes atingiram a média padrão.")
    else:
        print("As equipes não atingiram a média padrão.")

    print("================================")


# ============================================================
# MANIPULAÇÃO DO CSV
# ============================================================

def salvar_registro_manha(
    registro_id,
    data_registro,
    especie,
    veneno_manha,
    extraidas_manha,
    media_manha,
    media_padrao,
):
    linha = [
        registro_id,
        data_registro,
        especie,
        f"{veneno_manha:.4f}",
        extraidas_manha,
        f"{media_manha:.3f}",
        "",
        "",
        "",
        "",
        f"{media_padrao:.2f}",
    ]

    with open(CSV_FILE_PATH, "a", newline="", encoding="utf-8") as arquivo:
        escritor = csv.writer(arquivo)
        escritor.writerow(linha)


def atualizar_registro_tarde(
    registro_id,
    veneno_tarde,
    extraidas_tarde,
    media_tarde,
    media_dia,
):
    with open(CSV_FILE_PATH, "r", newline="", encoding="utf-8") as arquivo:
        linhas = list(csv.reader(arquivo))

    for linha in linhas[1:]:
        if linha and linha[0] == registro_id:
            linha[6] = f"{veneno_tarde:.4f}"
            linha[7] = str(extraidas_tarde)
            linha[8] = f"{media_tarde:.3f}"
            linha[9] = f"{media_dia:.3f}"
            break

    arquivo_temporario = None

    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            newline="",
            encoding="utf-8",
            delete=False,
            dir=DADOS_DIR,
        ) as temporario:
            arquivo_temporario = temporario.name
            escritor = csv.writer(temporario)
            escritor.writerows(linhas)

        os.replace(arquivo_temporario, CSV_FILE_PATH)

    finally:
        if arquivo_temporario and os.path.exists(arquivo_temporario):
            os.remove(arquivo_temporario)


# ============================================================
# PROGRAMA PRINCIPAL
# ============================================================

def gerar_id_registro():
    return datetime.now().strftime("%Y%m%d%H%M%S%f")


def executar():
    criar_csv_se_necessario()

    while True:
        registro_id = gerar_id_registro()
        data_registro = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        print("\n==============================================")
        print("NOVO REGISTRO DO DIA")
        print(f"ID: {registro_id}")
        print("==============================================")

        # ----------------------------------------------------
        # ESPÉCIE
        # ----------------------------------------------------

        especie, media_padrao = obter_especie_valida()

        # ----------------------------------------------------
        # DADOS DA MANHÃ
        # ----------------------------------------------------

        print("\n--- Dados da manhã ---")

        veneno_manha = obter_float_valido(
            "Veneno produzido pela manhã (g): "
        )

        extraidas_manha = obter_inteiro_valido(
            "Quantidade de aranhas extraídas pela manhã: "
        )

        media_manha = calcular_media(
            veneno_manha,
            extraidas_manha,
        )

        print(f"\nMédia da manhã: {media_manha:.3f} mg")

        salvar_registro_manha(
            registro_id,
            data_registro,
            especie,
            veneno_manha,
            extraidas_manha,
            media_manha,
            media_padrao,
        )

        print("Dados da manhã registrados com sucesso.")

        # ----------------------------------------------------
        # DADOS DA TARDE
        # ----------------------------------------------------

        print("\n--- Dados da tarde ---")

        veneno_tarde = obter_float_valido(
            "Veneno produzido pela tarde (g): "
        )

        extraidas_tarde = obter_inteiro_valido(
            "Quantidade de aranhas extraídas pela tarde: "
        )

        media_tarde = calcular_media(
            veneno_tarde,
            extraidas_tarde,
        )

        media_dia = calcular_media_dia(
            veneno_manha,
            extraidas_manha,
            veneno_tarde,
            extraidas_tarde,
        )

        atualizar_registro_tarde(
            registro_id,
            veneno_tarde,
            extraidas_tarde,
            media_tarde,
            media_dia,
        )

        print("\nDados da tarde registrados com sucesso.")
        print(f"Média da tarde: {media_tarde:.3f} mg")
        print(f"Média do dia: {media_dia:.3f} mg")

        imprimir_resultados(
            especie,
            media_manha,
            media_tarde,
            media_dia,
            media_padrao,
        )

        continuar = input(
            "\nDeseja cadastrar outro dia? (s/n): "
        ).strip().lower()

        if continuar != "s":
            break

    print("\n==============================================")
    print("Registros salvos no arquivo:")
    print(CSV_FILE_PATH)
    print("==============================================")


if __name__ == "__main__":
    executar()
