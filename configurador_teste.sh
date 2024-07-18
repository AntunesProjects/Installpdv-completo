#!/bin/bash

# Atualiza os pacotes
sudo apt update

# Instala o Git
sudo apt install -y git

# Clona o repositório na branch teste
git clone -b teste git@github.com:AntunesProjects/Installpdv-completo.git /tmp/pdv

# Acessa o diretório do repositório
cd /tmp/pdv

# Dá permissão de execução para o script
chmod +x installpdv.sh

# Executa o script
./installpdv.sh