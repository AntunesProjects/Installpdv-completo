#!/bin/bash

# Atualização de pacotes
sudo apt update
sudo apt upgrade -y

# Instalação dos pacotes de funcionalidades
sudo apt install -y vim cups net-tools lynx sshpass ntp ssh htop openjdk-11-jdk zip x11-xserver-utils gnome-terminal

# Instalação do AnyDesk
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list
sudo apt update
sudo apt install -y anydesk

# Instalação do Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable

# Instalação do TeamViewer
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb
sudo apt-get install -f -y

# Instalação de outros softwares
sudo apt install -y build-essential atril atril-common firefox

# Instalação do AutoSystem
wget -qO as_install.sh http://192.168.0.29/autosystem/as_install.sh
chmod +x as_install.sh
sudo ./as_install.sh

# Instalação do Mérito
wget -qO jposto.zip http://192.168.0.29/jposto.zip
sudo mv jposto.zip /opt/

# Configuração do CUPS
sudo systemctl stop cups-browsed
sudo systemctl disable cups-browsed

# Configuração de data e hora
sudo timedatectl set-timezone America/Sao_Paulo
timedatectl

# Instalação e configuração do ambiente gráfico (icewm e slim)
sudo apt update
sudo apt upgrade -y
sudo apt install -y xorg slim icewm

# Download e descompactação do toolbar_pdv.zip
cd /usr/share/icewm
sudo curl -O http://192.168.0.29/pdvconfig/toolbar_pdv.zip
sudo unzip toolbar_pdv.zip

# Criação dos scripts de desligamento e reinicialização
echo "#!/bin/bash" | sudo tee /usr/bin/desligamaquina.sh
echo "sudo shutdown -h now" | sudo tee -a /usr/bin/desligamaquina.sh
sudo chmod +x /usr/bin/desligamaquina.sh

echo "#!/bin/bash" | sudo tee /usr/bin/reiniciamaquina.sh
echo "sudo shutdown -r now" | sudo tee -a /usr/bin/reiniciamaquina.sh
sudo chmod +x /usr/bin/reiniciamaquina.sh

echo "Instalação e configuração concluídas!"
