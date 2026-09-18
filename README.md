# Projeto Calculadora de Rendimento de Veneno

Este projeto contém uma aplicação para registrar e calcular o rendimento médio de veneno produzido por diferentes espécies de aranhas.

O sistema registra os dados da manhã e da tarde, calcula as médias individuais e diárias, compara os resultados com uma média padrão por espécie e armazena as informações em um arquivo CSV.

Também existe um script Bash responsável por gerar um gráfico dos resultados utilizando o Gnuplot.

---

## Objetivos do projeto

O projeto foi desenvolvido para:

- Registrar a quantidade de veneno produzida;
- Registrar a quantidade de aranhas extraídas;
- Calcular a média de veneno por aranha;
- Converter os valores de gramas para miligramas;
- Comparar os resultados com uma média padrão;
- Armazenar os registros em formato CSV;
- Gerar gráficos de rendimento por registro.

---

## Estrutura do projeto

```text
Projeto_Calculadora/
├── calculadora_veneno.py
├── executar_calculadora.sh
├── gerar_grafico.sh
├── dados/
│   └── registros_diarios.csv
├── relatorios/
└── README.md
