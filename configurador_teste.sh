#!/bin/bash

# Atualiza os pacotes
sudo apt update

# Instala o Git
sudo apt install -y git

# Clona o repositório na branch teste usando HTTPS
git clone https://github.com/AntunesProjects/Installpdv-completo.git

# Acessa o diretório do repositório
cd Installpdv-completo

# Dá permissão de execução para o script
chmod +x installpdv.sh

# Executa o script
./installpdv.sh

