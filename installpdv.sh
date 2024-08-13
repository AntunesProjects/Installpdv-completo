#!/bin/bash

# Definição da variável de tempo de espera
WAIT_TIME=2
WAIT_HMG=3
LOGFILE="/var/log/install_script.log"

# Função para logar mensagens e erros
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

# Função para atualizar pacotes
update_system() {
    log "Iniciando atualização do sistema."
    sudo apt update >> $LOGFILE 2>&1
    sudo apt upgrade -y >> $LOGFILE 2>&1
    log "Atualização do sistema concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar pacotes de funcionalidades
install_functional_packages() {
    log "Instalando pacotes de funcionalidades."
    sudo apt install -y vim cups net-tools lynx sshpass ntp ssh htop openjdk-11-jdk zip x11-xserver-utils gnome-terminal mlocate system-config-printer >> $LOGFILE 2>&1
    log "Instalação de pacotes de funcionalidades concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar AnyDesk
install_anydesk() {
    log "Iniciando instalação do AnyDesk."
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add - >> $LOGFILE 2>&1
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list >> $LOGFILE 2>&1
    sudo apt update >> $LOGFILE 2>&1
    sudo apt install -y anydesk >> $LOGFILE 2>&1
    log "Instalação do AnyDesk concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar Google Chrome
install_chrome() {
    log "Iniciando instalação do Google Chrome."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - >> $LOGFILE 2>&1
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list >> $LOGFILE 2>&1
    sudo apt update >> $LOGFILE 2>&1
    sudo apt install -y google-chrome-stable >> $LOGFILE 2>&1
    log "Instalação do Google Chrome concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar TeamViewer
install_teamviewer() {
    log "Iniciando instalação do TeamViewer."
    wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb >> $LOGFILE 2>&1
    sudo dpkg -i teamviewer_amd64.deb >> $LOGFILE 2>&1
    sudo apt-get install -f -y >> $LOGFILE 2>&1
    log "Instalação do TeamViewer concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar outros softwares
install_other_software() {
    log "Instalando outros softwares."
    sudo apt install -y build-essential atril atril-common firefox >> $LOGFILE 2>&1
    log "Instalação de outros softwares concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalação do AutoSystem 
install_autosystem() {
    log "Iniciando instalação do AutoSystem."
    curl -O http://192.168.0.29/autosystem/as_install.sh >> $LOGFILE 2>&1
    chmod +x as_install.sh >> $LOGFILE 2>&1
    sudo ./as_install.sh >> $LOGFILE 2>&1
    log "Instalação do AutoSystem concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalação do Mérito
install_merito() {
    log "Iniciando instalação do Mérito."
    curl -O http://192.168.0.29/jposto_pdv.zip >> $LOGFILE 2>&1
    sudo cp jposto_pdv.zip /opt/ >> $LOGFILE 2>&1
    sudo unzip /opt/jposto_pdv.zip >> $LOGFILE 2>&1
    log "Instalação do Mérito concluída."
    sleep $WAIT_TIME
    clear
}

# Função para configuração do CUPS
configure_cups() {
    log "Configurando o CUPS."
    sudo apt install cups >> $LOGFILE 2>&1
    sudo systemctl stop cups-browsed >> $LOGFILE 2>&1
    sudo systemctl disable cups-browsed >> $LOGFILE 2>&1
    log "Configuração do CUPS concluída."
    sleep $WAIT_TIME
    clear
}

# Função para configurar data e hora
configure_time() {
    log "Configurando data e hora."
    sudo timedatectl set-timezone America/Sao_Paulo >> $LOGFILE 2>&1
    timedatectl >> $LOGFILE 2>&1
    log "Configuração de data e hora concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar e configurar ambiente gráfico
install_graphical_environment() {
    log "Instalando e configurando ambiente gráfico."
    sudo apt update >> $LOGFILE 2>&1
    sudo apt upgrade -y >> $LOGFILE 2>&1
    sudo apt install -y xorg slim icewm >> $LOGFILE 2>&1
    log "Instalação e configuração do ambiente gráfico concluída."
    sleep $WAIT_TIME
    clear
}

# Função para descompactar toolbar_pdv.zip
extract_toolbar() {
    log "Descompactando toolbar_pdv.zip."
    cd Installpdv-completo >> $LOGFILE 2>&1
    sudo cp toolbar_pdv.zip /usr/share/icewm >> $LOGFILE 2>&1
    cd /usr/share/icewm/ >> $LOGFILE 2>&1
    sudo unzip -o toolbar_pdv.zip >> $LOGFILE 2>&1
    log "Descompactação de toolbar_pdv.zip concluída."
    sleep $WAIT_TIME
    clear
}

# Função para criar scripts de desligamento e reinicialização
create_shutdown_restart_scripts() {
    log "Criando scripts de desligamento e reinicialização."
    echo "#!/bin/bash" | sudo tee /usr/bin/desligamaquina.sh >> $LOGFILE 2>&1
    echo "sudo shutdown -h now" | sudo tee -a /usr/bin/desligamaquina.sh >> $LOGFILE 2>&1
    sudo chmod +x /usr/bin/desligamaquina.sh >> $LOGFILE 2>&1

    echo "#!/bin/bash" | sudo tee /usr/bin/reiniciamaquina.sh >> $LOGFILE 2>&1
    echo "sudo shutdown -r now" | sudo tee -a /usr/bin/reiniciamaquina.sh >> $LOGFILE 2>&1
    sudo chmod +x /usr/bin/reiniciamaquina.sh >> $LOGFILE 2>&1
    log "Scripts de desligamento e reinicialização criados."
    sleep $WAIT_TIME
    clear
}

# Função para atualizar o CUPS
update_cups() {
    log "Atualizando o CUPS."
    sed -i 's|ExecStart=/usr/sbin/cupsd|ExecStart=/usr/sbin/cupsd -f|' /lib/systemd/system/cups.service >> $LOGFILE 2>&1
    systemctl daemon-reload >> $LOGFILE 2>&1
    systemctl restart cups.service >> $LOGFILE 2>&1
    log "Atualização do CUPS concluída."
    sleep $WAIT_TIME
    clear
}

# Função para ativar o Modo Texto
activate_text_mode() {
    log "Ativando modo texto."
    #sudo getty -8 38400 tty2 >> $LOGFILE 2>&1
    log "Modo texto ativado."
    sleep $WAIT_TIME
    clear
}

# Função para configurar aplicativo padrão PDF
configure_pdf_app() {
    log "Configurando aplicativo padrão PDF."
    sed -i 's|# deb http://archive.canonical.com/ubuntu xenial partner|deb http://archive.canonical.com/ubuntu xenial partner|' /etc/apt/sources.list >> $LOGFILE 2>&1
    apt-get update >> $LOGFILE 2>&1
    apt-get install -y xdg-utils >> $LOGFILE 2>&1
    log "Configuração do aplicativo padrão PDF concluída."
    sleep $WAIT_TIME
    clear
}

# Função para configurar permissões dos periféricos
configure_peripheral_permissions() {
    log "Configurando permissões dos periféricos."
    cat <<EOL >> /etc/udev/rules.d/40-permissions.rules
KERNEL=="ttyS[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyUSB[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="lp[0-9]", GROUP="dialout", MODE="0777"
KERNEL=="ttyACM[0-9]", GROUP="dialout", MODE="0777"
EOL
    log "Permissões dos periféricos configuradas."
    sleep $WAIT_TIME
    clear
}

# Função para desabilitar proteção de tela
disable_screensaver() {
    log "Desabilitando proteção de tela."
    cat <<EOL >> /etc/profile
/usr/bin/xset dpms 0 0 0
/usr/bin/xset s off
/usr/bin/xset -dpms
EOL
    log "Proteção de tela desabilitada."
    sleep $WAIT_TIME
    clear
}

# Função para configurar GRUB
configure_grub() {
    log "Configurando GRUB."
    sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 text"|' /etc/default/grub >> $LOGFILE 2>&1
    update-grub >> $LOGFILE 2>&1
    log "Configuração do GRUB concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar complementos do Autosystem
install_autosystem_complements() {
    log "Instalando complementos do Autosystem."
    apt-get install -y libxmlsec1 libxmlsec1-dev xmlsec1 libgdk-pixbuf2.0-dev >> $LOGFILE 2>&1
    log "Complementos do Autosystem instalados."
    sleep $WAIT_TIME
    clear
}

# Função para instalar bibliotecas TEF
install_tef_libraries() {
    log "Instalando bibliotecas TEF."
    cp /caminho/para/libs-tef/* /usr/lib/ >> $LOGFILE 2>&1
    log "Bibliotecas TEF instaladas."
    sleep $WAIT_TIME
    clear
}

# Função para instalar logs do sistema operacional
install_syslogs() {
    log "Instalando logs do sistema operacional."
    apt-get install -y syslog-ng gnome-system-log >> $LOGFILE 2>&1
    log "Logs do sistema operacional instalados."
    sleep $WAIT_TIME
    clear
}

# Função para habilitar NumLock ao iniciar o SO
enable_numlock() {
    log "Habilitando NumLock ao iniciar o SO."
    apt-get install -y numlockx >> $LOGFILE 2>&1
    echo "greeter-setup-script=/usr/bin/numlockx on" >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf >> $LOGFILE 2>&1
    log "NumLock habilitado ao iniciar o SO."
    sleep $WAIT_TIME
    clear
}

# Função para desabilitar modo pausa da impressora
disable_printer_pause() {
    log "Desabilitando modo pausa da impressora."
    cat <<EOL > /usr/local/bin/startprinter.sh
#!/bin/bash
lpstat -t | grep disable | awk '{print \$2}' > printers_temp
for i in \$(cat printers_temp); do cupsenable \$i; done
cancel -a -x
EOL
    chmod +x /usr/local/bin/startprinter.sh >> $LOGFILE 2>&1
    echo "0-59/5 * * * * root /usr/local/bin/startprinter.sh" >> /etc/crontab >> $LOGFILE 2>&1
    /etc/init.d/cron restart >> $LOGFILE 2>&1
    log "Modo pausa da impressora desabilitado."
    sleep $WAIT_TIME
    clear
}

# Função para instalar fontes para leitura de documentos
install_fonts() {
    log "Instalando fontes para leitura de documentos."
    apt-get install -y msttcorefonts >> $LOGFILE 2>&1
    log "Fontes para leitura de documentos instaladas."
    sleep $WAIT_TIME
    clear
}

# Função para configurar NTP
configure_ntp() {
    log "Configurando NTP."
    ntpq >> $LOGFILE 2>&1
    log "Configuração do NTP concluída."
    sleep $WAIT_TIME
    clear
}

# Função para instalar dependências do Virt-Manager
install_virtmanager_dependencies() {
    log "Instalando dependências do Virt-Manager."
    apt-get install -y build-essential checkinstall zlib1g-dev libssl-dev >> $LOGFILE 2>&1
    log "Dependências do Virt-Manager instaladas."
    sleep $WAIT_TIME
    clear
}

# Função para baixar e copiar o arquivo libjCliSiTefI.so
install_jlibs() {
    log "Baixando o arquivo libjCliSiTefI.so."
    curl -O http://192.168.0.29/pdvconfig/jlibs/libjCliSiTefI.so >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        log "Download do arquivo libjCliSiTefI.so concluído."
        log "Copiando o arquivo para os diretórios especificados."
        sudo cp libjCliSiTefI.so /usr/java/package/lib/ >> $LOGFILE 2>&1
        sudo cp libjCliSiTefI.so /usr/lib/x86_64-linux-gnu/jni/ >> $LOGFILE 2>&1
        sudo cp libjCliSiTefI.so /lib/x86_64-linux-gnu/ >> $LOGFILE 2>&1
        sudo cp libjCliSiTefI.so /usr/lib/jni/ >> $LOGFILE 2>&1
        sudo cp libjCliSiTefI.so /lib/ >> $LOGFILE 2>&1
        sudo cp libjCliSiTefI.so /usr/lib/ >> $LOGFILE 2>&1
        log "Arquivo copiado com sucesso para todos os diretórios."
    else
        log "Erro ao baixar o arquivo libjCliSiTefI.so."
    fi
    sleep $WAIT_TIME
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

#install_autosystem
echo "Autosystem: Off"
sleep $WAIT_HMG

#install_merito
echo "Mérito: Off"
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

install_jlibs
echo "libjCliSiTefI.so: end"
sleep $WAIT_TIME

echo "Instalação e configuração concluídas com sucesso!"
