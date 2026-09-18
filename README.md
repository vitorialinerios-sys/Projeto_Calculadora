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

## Descrição dos Arquivos

"calculadora_veneno.py" - É o programa principal desenvolvido em Python.

Ele realiza:

Validação da espécie informada;
Validação dos valores numéricos;
Registro dos dados da manhã;
Registro dos dados da tarde;
Cálculo das médias;
Comparação com a média padrão;
Atualização do arquivo CSV.

"executar_calculadora.sh" - É um script Bash usado para executar o programa Python.

Ele chama o arquivo:

bash:
python3 calculadora_veneno.py

gerar_grafico.sh - É um script Bash que utiliza o programa Gnuplot para gerar um gráfico com os dados registrados no arquivo CSV.

O gráfico é salvo na pasta:

bash
relatorios/
dados/registros_diarios.csv
Arquivo que armazena os registros realizados pela calculadora.

relatorios/
Pasta destinada aos arquivos de imagem gerados pelo Gnuplot.

## Requisitos

Para executar o projeto, são necessários:

* Python 3;
* Bash;
* Git, caso o projeto seja clonado pelo terminal;
* Gnuplot, para gerar os gráficos.

O programa Python utiliza apenas bibliotecas padrão da linguagem. Não é necessário instalar bibliotecas externas para executar a calculadora.

## Como obter o projeto

bash
git clone https://github.com/vitorialinerios-sys/Projeto_Calculadora.git
Acesse a pasta do projeto:

bash
cd Projeto_Calculadora

## Como executar a calculadora usando Python

A forma principal de executar o projeto é utilizando o Python:

bash
python3 calculadora_veneno.py
Em alguns computadores com Windows, o comando pode ser:

bash
python calculadora_veneno.py
Ao iniciar, o programa solicitará a espécie e os dados de produção do veneno.

## Como executar utilizando o arquivo ".sh"

O arquivo executar_calculadora.sh pode ser utilizado para iniciar a calculadora.

Primeiro, dê permissão de execução:

bash
chmod +x executar_calculadora.sh
Depois, execute:

bash
./executar_calculadora.sh
O script Bash localizará automaticamente o arquivo calculadora_veneno.py dentro da pasta do projeto.

## Funiomamento da Calculadora

O programa solicita os seguintes dados:

Espécie da aranha;
Quantidade de veneno produzida pela manhã, em gramas;
Quantidade de aranhas extraídas pela manhã;
Quantidade de veneno produzida à tarde, em gramas;
Quantidade de aranhas extraídas à tarde.
As espécies disponíveis são:

* L. gaucho
* L. intermedia
* L. laeta

O programa também aceita valores decimais utilizando ponto ou vírgula. Por exemplo:

copiar
0.1102
ou:

copiar
0,1102

## Cálculos Utilizado

Média da manhã ou da tarde
A média é calculada dividindo a quantidade de veneno pela quantidade de aranhas.

O resultado inicialmente está em gramas por aranha. Em seguida, ele é convertido para miligramas:

copiar
média em gramas = veneno produzido / quantidade de aranhas

média em miligramas = média em gramas × 1000

Média do dia
A média do dia considera o total produzido nos dois períodos:

veneno total = veneno da manhã + veneno da tarde

aranhas totais = aranhas da manhã + aranhas da tarde

média do dia = veneno total / aranhas totais

O resultado também é convertido de gramas para miligramas.

## Arquivo CVC

O arquivo dados/registros_diarios.csv é criado automaticamente quando a calculadora é executada pela primeira vez.

Ele possui as seguintes colunas:

id_registro
data_registro
especie
veneno_manha_g
extraidas_manha
media_manha_mg
veneno_tarde_g
extraidas_tarde
media_tarde_mg
media_dia_mg
media_padrao_mg

## Como gerar o gráfico

O arquivo gerar_grafico.sh utiliza o Gnuplot para gerar um gráfico a partir do arquivo:

dados/registros_diarios.csv
Antes de executar, certifique-se de que o Gnuplot está instalado.

Instalação no Ubuntu ou Debian

sudo apt update
sudo apt install gnuplot-nox

Execução
Dê permissão ao arquivo:

chmod +x gerar_grafico.sh

Execute:

./gerar_grafico.sh

O gráfico será salvo na pasta:

relatorios/
O nome do arquivo terá o seguinte formato:

grafico_rendimento_AAAA-MM-DD.png

## Execução no Google Colab

O projeto também pode ser executado no Google Colab.

Clone o repositório:

!git clone https://github.com/vitorialinerios-sys/Projeto_Calculadora.git
Acesse a pasta:

%cd /content/Projeto_Calculadora
Execute a calculadora:

!python3 calculadora_veneno.py

Para instalar o Gnuplot no Colab:

!apt-get update -qq
!apt-get install -y gnuplot-nox

Depois, execute o gerador de gráficos:

!chmod +x gerar_grafico.sh
!./gerar_grafico.sh

Os arquivos gerados podem ser visualizados na pasta relatorios.

## Execução no Windows

O arquivo Python pode ser executado normalmente no Windows, desde que o Python esteja instalado:

python calculadora_veneno.py

Para executar os arquivos .sh no Windows, pode ser utilizado um dos seguintes ambientes:

* Git Bash;
* WSL — Windows Subsystem for Linux;
* Linux virtualizado;
* Google Colab.

## Autoria

Projeto desenvolvido por:

Vitoria Rios

