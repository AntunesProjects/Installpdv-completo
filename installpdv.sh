#!/bin/bash

# Definição da variável de tempo de espera
WAIT_TIME=2
WAIT_HMG=3

# Função para atualizar pacotes
update_system() {
    sudo apt update
    sudo apt upgrade -y
    clear
}

# Função para instalar pacotes de funcionalidades
install_functional_packages() {
    sudo apt install -y vim cups net-tools lynx sshpass ntp ssh htop openjdk-11-jdk zip x11-xserver-utils gnome-terminal
    clear
}

# Função para instalar AnyDesk
install_anydesk() {
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list
    sudo apt update
    sudo apt install -y anydesk
    clear
}

# Função para instalar Google Chrome
install_chrome() {
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
    clear
}

# Função para instalar TeamViewer
install_teamviewer() {
    wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
    sudo dpkg -i teamviewer_amd64.deb
    sudo apt-get install -f -y
    clear
}

# Função para instalar outros softwares
install_other_software() {
    sudo apt install -y build-essential atril atril-common firefox
    clear
}

# Função para instalação do AutoSystem 
install_autosystem() {
    curl -O http://192.168.0.29/autosystem/as_install.sh
    chmod +x as_install.sh
    sudo ./as_install.sh
    clear
}

# Função para instalação do Mérito
install_merito() {
    curl -O http://192.168.0.29/jposto_pdv.zip
    sudo cp jposto_pdv.zip /opt/
    sudo unzip /opt/jposto_pdv.zip
    clear
}

# Função para configuração do CUPS
configure_cups() {
    sudo apt install cups
    sudo systemctl stop cups-browsed
    sudo systemctl disable cups-browsed
    clear
}

# Função para configurar data e hora
configure_time() {
    sudo timedatectl set-timezone America/Sao_Paulo
    timedatectl
    clear
}

# Função para instalar e configurar ambiente gráfico
install_graphical_environment() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y xorg slim icewm
    clear
}

# Função para descompactar toolbar_pdv.zip
extract_toolbar() {
    cd Installpdv-completo
    sudo cp toolbar_pdv.zip /usr/share/icewm
    cd /usr/share/icewm/
    sudo unzip -o toolbar_pdv.zip
    clear
}

# Função para criar scripts de desligamento e reinicialização
create_shutdown_restart_scripts() {
    echo "#!/bin/bash" | sudo tee /usr/bin/desligamaquina.sh
    echo "sudo shutdown -h now" | sudo tee -a /usr/bin/desligamaquina.sh
    sudo chmod +x /usr/bin/desligamaquina.sh

    echo "#!/bin/bash" | sudo tee /usr/bin/reiniciamaquina.sh
    echo "sudo shutdown -r now" | sudo tee -a /usr/bin/reiniciamaquina.sh
    sudo chmod +x /usr/bin/reiniciamaquina.sh
    clear
}

# Função para atualizar o CUPS
update_cups() {
    sed -i 's|ExecStart=/usr/sbin/cupsd|ExecStart=/usr/sbin/cupsd -f|' /lib/systemd/system/cups.service
    systemctl daemon-reload
    systemctl restart cups.service
    clear
}

# Função para ativar o Modo Texto
activate_text_mode() {
    #sudo getty -8 38400 tty2
    clear
}

# Função para configurar aplicativo padrão PDF
configure_pdf_app() {
    sed -i 's|# deb http://archive.canonical.com/ubuntu xenial partner|deb http://archive.canonical.com/ubuntu xenial partner|' /etc/apt/sources.list
    apt-get update
    apt-get install -y xdg-utils
    clear
}

# Função para configurar permissões dos periféricos
configure_peripheral_permissions() {
    cat <<EOL >> /etc/udev/rules.d/40-permissions.rules
KERNEL=="ttyS[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyUSB[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="lp[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyACM[0-9]", GROUP="dialout", MODE="0777"
EOL
    clear
}

# Função para desabilitar proteção de tela
disable_screensaver() {
    cat <<EOL >> /etc/profile
/usr/bin/xset dpms 0 0 0
/usr/bin/xset s off
/usr/bin/xset -dpms
EOL
    clear
}

# Função para configurar GRUB
configure_grub() {
    sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 text"|' /etc/default/grub
    update-grub
    clear
}

# Função para instalar complementos do Autosystem
install_autosystem_complements() {
    apt-get install -y libxmlsec1 libxmlsec1-dev xmlsec1 libgdk-pixbuf2.0-dev
    clear
}

# Função para instalar bibliotecas TEF
install_tef_libraries() {
    cp /caminho/para/libs-tef/* /usr/lib/
    clear
}

# Função para instalar logs do sistema operacional
install_syslogs() {
    apt-get install -y syslog-ng gnome-system-log
    clear
}

# Função para habilitar NumLock ao iniciar o SO
enable_numlock() {
    apt-get install -y numlockx
    echo "greeter-setup-script=/usr/bin/numlockx on" >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
    clear
}

# Função para desabilitar modo pausa da impressora
disable_printer_pause() {
    cat <<EOL > /usr/local/bin/startprinter.sh
#!/bin/bash
lpstat -t | grep disable | awk '{print \$2}' > printers_temp
for i in \$(cat printers_temp); do cupsenable \$i; done
cancel -a -x
EOL
    chmod +x /usr/local/bin/startprinter.sh
    echo "0-59/5 * * * * root /usr/local/bin/startprinter.sh" >> /etc/crontab
    /etc/init.d/cron restart
    clear
}

# Função para instalar fontes para leitura de documentos
install_fonts() {
    apt-get install -y msttcorefonts
    clear
}

# Função para configurar NTP
configure_ntp() {
    #ntpq
    clear
}

# Função para instalar dependências do Virt-Manager
install_virtmanager_dependencies() {
    apt-get install -y build-essential checkinstall zlib1g-dev libssl-dev
    clear
}

# Execução das funções com echo e sleep após cada função
update_system
echo "update/upgrade: end"
sleep $WAIT_TIME

install_functional_packages
echo "pacotes de funcionalidades: end"
sleep $WAIT_TIME

install_anydesk
echo "Anydesk: end"
sleep $WAIT_TIME

install_chrome
echo "Chrome: end"
sleep $WAIT_TIME

install_teamviewer
echo "Teamviewer: end"
sleep $WAIT_TIME

install_other_software
echo "atril: end"
sleep $WAIT_TIME

install_autosystem
echo "Autosystem: Teste"
sleep $WAIT_HMG

install_merito
echo "Mérito: Teste"
sleep $WAIT_HMG

configure_cups
echo "cups: end"
sleep $WAIT_TIME

configure_time
echo "Data e hora: end"
sleep $WAIT_TIME

install_graphical_environment
echo "Ambiente gráfico: end"
sleep $WAIT_TIME

extract_toolbar
echo "Toolbar: Teste"
sleep $WAIT_TIME

create_shutdown_restart_scripts
echo "Script liga/desliga: end"
sleep $WAIT_TIME

update_cups
echo "Cups config: end"
sleep $WAIT_TIME

activate_text_mode
echo "Modo de texto: pausada"
sleep $WAIT_TIME

configure_pdf_app
echo "pdf config: end"
sleep $WAIT_TIME

configure_peripheral_permissions
echo "perifericos config: end"
sleep $WAIT_TIME

disable_screensaver
echo "tela config: end"
sleep $WAIT_TIME

configure_grub
echo "grub config: end"
sleep $WAIT_TIME

install_autosystem_complements
echo "autosystem config: end"
sleep $WAIT_TIME

install_tef_libraries
echo "Libs tef config: Não configurado"
sleep $WAIT_TIME

install_syslogs
echo "log config: end"
sleep $WAIT_TIME

enable_numlock
echo "numlock config: end"
sleep $WAIT_TIME

disable_printer_pause
echo "Impressora config: end"
sleep $WAIT_TIME

install_fonts
echo "fotes config: end"
sleep $WAIT_TIME

#configure_ntp
echo "ntp config: desabilitado (ultrapassado)"
sleep $WAIT_TIME

install_virtmanager_dependencies
echo "virt manager config: end"
sleep $WAIT_TIME

echo "Instalação e configuração concluídas com sucesso!"
