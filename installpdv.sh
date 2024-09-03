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
    sudo apt install -y vim cups net-tools lynx sshpass ntp ssh htop openjdk-11-jdk zip x11-xserver-utils gnome-terminal mlocate system-config-printer
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

    # Configurar o SLiM para iniciar o IceWM
    #sudo sed -i 's|^login_cmd .*|login_cmd exec /bin/bash -login /etc/X11/Xsession icewm|' /etc/slim.conf

    # Definir o SLiM como o gerenciador de exibição padrão
    #echo "slim" | sudo tee /etc/X11/default-display-manager

    # Remover pacotes desnecessários do GNOME (opcional)
    sudo apt remove --purge -y ubuntu-desktop gnome-shell
    sudo apt autoremove -y
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
    # Criar o script para desligar a máquina
    sudo tee /usr/bin/desligamaquina.sh > /dev/null << 'EOF'
#!/bin/bash
# Desliga a máquina imediatamente
sudo shutdown -h now
EOF

    # Tornar o script executável
    sudo chmod +x /usr/bin/desligamaquina.sh

    # Criar o script para reiniciar a máquina
    sudo tee /usr/bin/reiniciamaquina.sh > /dev/null << 'EOF'
#!/bin/bash
# Reinicia a máquina imediatamente
sudo shutdown -r now
EOF

    # Tornar o script executável
    sudo chmod +x /usr/bin/reiniciamaquina.sh

    # Limpar a tela após a criação dos scripts
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

## CONFIGURAÇÕES ##

##Netplan
    function confNetplan(){
        echo "# This is the network config written by "subiquity"
network:
 ethernets:
  eth0:
   addresses:
   - $ip/24
   gateway4: $mgateway
   nameservers:
     addresses:
     - $mdns
     search:
      - buffon.com.br
 version: 2" > /etc/netplan/00-installer-config.yaml
    }

##sshd
    function confSSHD(){
        echo "
        # This is the sshd server system-wide configuration file.  See
        # sshd_config(5) for more information.

        # This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

        # The strategy used for options in the default sshd_config shipped with
        # OpenSSH is to specify options with their default value where
        # possible, but leave them commented.  Uncommented options override the
        # default value.

        Include /etc/ssh/sshd_config.d/*.conf

        Port 221$pdv
        #AddressFamily any
        #ListenAddress 0.0.0.0
        #ListenAddress ::

        #HostKey /etc/ssh/ssh_host_rsa_key
        #HostKey /etc/ssh/ssh_host_ecdsa_key
        #HostKey /etc/ssh/ssh_host_ed25519_key

        # Ciphers and keying
        #RekeyLimit default none

        # Logging
        #SyslogFacility AUTH
        #LogLevel INFO

        # Authentication:

        #LoginGraceTime 2m
        PermitRootLogin yes
        #StrictModes yes
        #MaxAuthTries 6
        #MaxSessions 10

        #PubkeyAuthentication yes

        # Expect .ssh/authorized_keys2 to be disregarded by default in future.
        #AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

        #AuthorizedPrincipalsFile none

        #AuthorizedKeysCommand none
        #AuthorizedKeysCommandUser nobody

        # For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
        #HostbasedAuthentication no
        # Change to yes if you don't trust ~/.ssh/known_hosts for
        # HostbasedAuthentication
        #IgnoreUserKnownHosts no
        # Don't read the user's ~/.rhosts and ~/.shosts files
        #IgnoreRhosts yes

        # To disable tunneled clear text passwords, change to no here!
        #PasswordAuthentication yes
        #PermitEmptyPasswords no

        # Change to yes to enable challenge-response passwords (beware issues with
        # some PAM modules and threads)
        KbdInteractiveAuthentication no

        # Kerberos options
        #KerberosAuthentication no
        #KerberosOrLocalPasswd yes
        #KerberosTicketCleanup yes
        #KerberosGetAFSToken no

        # GSSAPI options
        #GSSAPIAuthentication no
        #GSSAPICleanupCredentials yes
        #GSSAPIStrictAcceptorCheck yes
        #GSSAPIKeyExchange no

        # Set this to 'yes' to enable PAM authentication, account processing,
        # and session processing. If this is enabled, PAM authentication will
        # be allowed through the KbdInteractiveAuthentication and
        # PasswordAuthentication.  Depending on your PAM configuration,
        # PAM authentication via KbdInteractiveAuthentication may bypass
        # the setting of "PermitRootLogin without-password".
        # If you just want the PAM account and session checks to run without
        # PAM authentication, then enable this but set PasswordAuthentication
        # and KbdInteractiveAuthentication to 'no'.
        UsePAM yes

        #AllowAgentForwarding yes
        #AllowTcpForwarding yes
        #GatewayPorts no
        X11Forwarding yes
        #X11DisplayOffset 10
        #X11UseLocalhost yes
        #PermitTTY yes
        PrintMotd no
        #PrintLastLog yes
        #TCPKeepAlive yes
        #PermitUserEnvironment no
        #Compression delayed
        #ClientAliveInterval 0
        #ClientAliveCountMax 3
        #UseDNS no
        #PidFile /run/sshd.pid
        #MaxStartups 10:30:100
        #PermitTunnel no
        #ChrootDirectory none
        #VersionAddendum none

        # no default banner path
        #Banner none

        # Allow client to pass locale environment variables
        AcceptEnv LANG LC_*

        # override default of no subsystems
        Subsystem sftp  /usr/lib/openssh/sftp-server

        # Example of overriding settings on a per-user basis
        #Match User anoncvs
        #       X11Forwarding no
        #       AllowTcpForwarding no
        #       PermitTTY no
        #       ForceCommand cvs server
        PasswordAuthentication yes
        " > /etc/ssh/sshd_config
            }

##merito
    function attMerito(){
        cd /opt
        curl -O http://192.168.0.29/jposto.zip
        unzip jposto.zip
        echo "#Fri Feb 24 08:08:34 BRT 2023
BD=jposto
IP=10.12.$posto.254
SENHA=0x6fy0x78y0x6by0x62y0x68y0x6ey
EMPRESA=001
UNIDADE=$posto
USUARIO=0x70y0x6fy0x73y0x74y0x67y0x72y0x65y0x73y" > /opt/jposto/bin/com/resources/conf.properties
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
echo "Ambiente gráfico: Teste"
sleep $WAIT_TIME

extract_toolbar
echo "Toolbar: Teste"
sleep $WAIT_TIME

create_shutdown_restart_scripts
echo "Script liga/desliga: Teste"
sleep $WAIT_TIME

update_cups
echo "Cups config: end"
sleep $WAIT_TIME

#activate_text_mode
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

#install_tef_libraries
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

#inicio do script
while true; do
    echo "Digite o posto"

    read posto
    echo " "

    echo "Digite o pdv"

    read pdv
    echo " "
    sleep 1

    clear
    echo "Confirme as informações:"
    echo "Posto: $posto"
    echo "PDV: $pdv"
    echo " "
    echo " "
    
    sleep 1
    echo "1. Confirmar"
    echo "2. Corrigir"

    read opcao
    clear

    case $opcao in
        1)       
        #Teamviewer
        echo "instalando teamviewer"
        sleep 2
            cd /usr/src
            $awget $teamviewer
            instTeamviewer
                clear
            sleep 2
        echo "Teamviewer instalado"
        sleep 2
                clear

        #Anydesk
        echo "instalando Anydesk"
        sleep 2
            instAnydesk
                clear
        echo "Anydesk instalado"
        sleep 2
                clear

        #Config rede final
        ip="10.12.$posto.1$pdv"
        mgateway="10.12.$posto.254"
        mdns="10.12.$posto.254"       

        #Ajuste de netplan 
        echo "configurando netplan"
        sleep 1
        confNetplanDHCP
        clear
        echo "netplan configurado"
        clear

        #Ajuste de ssh 
        echo "configurando ssh"
        sleep 2
            confSSHD
                clear
        echo "ssh configurado"
        echo " "
        sleep 2
                clear

        #Ajuste anydesk final
        #VPN


            #Atualizando sistemas
            while true; do
            
            echo "Atualizando o sistema do PDV"
            echo " "
            sleep 1
            echo "1. Autosystem"
            echo "2. Merito"

            read system

                case $system in
                    1)  
                        #Instruções para config final
                        echo " "
                        echo " "
                        echo "INSTRUÇÕES PARA CONFIGURAÇÕES FINAIS"
                        echo " "
                        sleep 1
                        echo "COMO USER, EXECUTE:"
                        echo " " 
                        sleep 1
                        echo "as_config:"
                        echo "PBUFQxxx (final do cnpj)"
                        echo "SE000xxx (posto + n do pdv)"
                        echo " "
                        sleep 1
                        echo "Configurar teamviewer"
                        echo "Reinicar a maquina"
                        break 2
                        ;;

                        2)  
                        echo "Baixando jposto"
                        sleep 1
                        attMerito
                        clear
                        echo "Instalação finalizada"
                        break 2
                        ;;
                esac
            done
            ;;            


        2)
            echo "Corrigindo informações"
            echo " "
            ;;
    esac
done