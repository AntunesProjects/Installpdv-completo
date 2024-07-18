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
curl -O http://192.168.0.29/autosystem/as_install.sh
chmod +x as_install.sh
sudo ./as_install.sh

# Instalação do Mérito
curl -O http://192.168.0.29/jposto_pdv.zip
sudo cp jposto_pdv.zip /opt/
sudo unzip /opt/jposto_pdv.zip

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
cp toolbar_pdv.zip /usr/share/icewm
sudo unzip /usr/share/icewm/toolbar_pdv.zip

# Criação dos scripts de desligamento e reinicialização
echo "#!/bin/bash" | sudo tee /usr/bin/desligamaquina.sh
echo "sudo shutdown -h now" | sudo tee -a /usr/bin/desligamaquina.sh
sudo chmod +x /usr/bin/desligamaquina.sh

echo "#!/bin/bash" | sudo tee /usr/bin/reiniciamaquina.sh
echo "sudo shutdown -r now" | sudo tee -a /usr/bin/reiniciamaquina.sh
sudo chmod +x /usr/bin/reiniciamaquina.sh

# Função para atualizar o CUPS
update_cups() {
    echo "Atualizando o serviço CUPS..."
    sed -i 's|ExecStart=/usr/sbin/cupsd|ExecStart=/usr/sbin/cupsd -f|' /lib/systemd/system/cups.service
    systemctl daemon-reload
    systemctl restart cups.service
}

# Função para ativar o Modo Texto
activate_text_mode() {
    echo "Ativando o Modo Texto..."
    sudo getty -8 38400 tty2
}

# Função para configurar aplicativo padrão PDF
configure_pdf_app() {
    echo "Configurando aplicativo padrão PDF..."
    sed -i 's|# deb http://archive.canonical.com/ubuntu xenial partner|deb http://archive.canonical.com/ubuntu xenial partner|' /etc/apt/sources.list
    apt-get update
    apt-get install -y xdg-utils
}

# Função para configurar permissões dos periféricos
configure_peripheral_permissions() {
    echo "Configurando permissões dos periféricos..."
    cat <<EOL >> /etc/udev/rules.d/40-permissions.rules
KERNEL=="ttyS[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyUSB[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="lp[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyACM[0-9]", GROUP="dialout", MODE="0777"
EOL
}

# Função para desabilitar proteção de tela
disable_screensaver() {
    echo "Desabilitando proteção de tela..."
    cat <<EOL >> /etc/profile
/usr/bin/xset dpms 0 0 0
/usr/bin/xset s off
/usr/bin/xset -dpms
EOL
}

# Função para configurar GRUB
configure_grub() {
    echo "Configurando GRUB..."
    sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 text"|' /etc/default/grub
    update-grub
}

# Função para instalar complementos do Autosystem
install_autosystem_complements() {
    echo "Instalando complementos do Autosystem..."
    apt-get install -y libxmlsec1 libxmlsec1-dev xmlsec1 libgdk-pixbuf2.0-dev
}

# Função para instalar bibliotecas TEF
install_tef_libraries() {
    echo "Instalando bibliotecas TEF..."
    cp /caminho/para/libs-tef/* /usr/lib/
}

# Função para instalar logs do sistema operacional
install_syslogs() {
    echo "Instalando logs do sistema operacional..."
    apt-get install -y syslog-ng gnome-system-log
}

# Função para habilitar NumLock ao iniciar o SO
enable_numlock() {
    echo "Habilitando NumLock ao iniciar o SO..."
    apt-get install -y numlockx
    echo "greeter-setup-script=/usr/bin/numlockx on" >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
}

# Função para desabilitar modo pausa da impressora
disable_printer_pause() {
    echo "Desabilitando modo pausa da impressora..."
    cat <<EOL > /usr/local/bin/startprinter.sh
#!/bin/bash
lpstat -t | grep disable | awk '{print \$2}' > printers_temp
for i in \$(cat printers_temp); do cupsenable \$i; done
cancel -a -x
EOL
    chmod +x /usr/local/bin/startprinter.sh
    echo "0-59/5 * * * * root /usr/local/bin/startprinter.sh" >> /etc/crontab
    /etc/init.d/cron restart
}

# Função para instalar fontes para leitura de documentos
install_fonts() {
    echo "Instalando fontes para leitura de documentos..."
    apt-get install -y msttcorefonts
}

# Função para configurar NTP
configure_ntp() {
    echo "Configurando NTP..."
    ntpq
}

# Função para instalar dependências do Virt-Manager
install_virtmanager_dependencies() {
    echo "Instalando dependências do Virt-Manager..."
    apt-get install -y build-essential checkinstall zlib1g-dev libssl-dev
}

# Execução das funções
update_cups
activate_text_mode
configure_pdf_app
configure_peripheral_permissions
disable_screensaver
configure_grub
install_autosystem_complements
install_tef_libraries
install_syslogs
enable_numlock
disable_printer_pause
install_fonts
configure_ntp
install_virtmanager_dependencies

echo "Instalação e configuração concluídas com sucesso!"