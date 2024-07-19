#!/bin/bash

# Função para verificar e esperar a liberação dos locks
wait_for_locks() {
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
          fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
          fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
          fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
        echo "Esperando pelo processo de gerenciamento de pacotes finalizar..."
        sleep 1
    done
}

# Verifica e espera a liberação dos locks antes de iniciar
wait_for_locks

# Atualiza os pacotes
sudo apt update

# Instala o Git
sudo apt install -y git

# Verifica e espera a liberação dos locks após instalar o Git
wait_for_locks

# Clona o repositório na branch teste usando HTTPS
git https://github.com/AntunesProjects/Installpdv-completo.git /tmp/pdv

# Acessa o diretório do repositório
cd /tmp/pdv

# Dá permissão de execução para o script
chmod +x installpdv.sh

# Executa o script
./installpdv.sh
