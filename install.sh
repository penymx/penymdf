+#!/bin/bash
+
+cores () {
+dialog --create-rc $HOME/.dialogrc
+echo "# Tema "Verde" tipo console para o Dialog.
+# Autor: Aurelio Marinho Jargas
+#   Salvar este arquivo como $HOME/.dialogrc
+#   ou definir a vari�vel $DIALOGRC
+
+# screen
+use_shadow   = ON
+use_colors   = ON
+screen_color = (WHITE,BLACK,ON)
+# box
+dialog_color = (RED,WHITE,ON)
+title_color  = (BLACK,WHITE,ON)
+border_color = (BLACK,WHITE,ON)
+# button
+button_active_color         = (RED,WHITE,ON)
+button_inactive_color       = (RED,WHITE,ON)
+button_key_active_color     = (BLACK,WHITE,OFF)
+button_key_inactive_color   = (RED,WHITE,ON)
+button_label_active_color   = (BLACK,WHITE,OFF)
+button_label_inactive_color = (RED,WHITE,ON)
+# input
+inputbox_color        = (RED,WHITE,ON)
+inputbox_border_color = (RED,WHITE,ON)
+# textbox
+searchbox_color          = (RED,WHITE,ON)
+searchbox_title_color    = (RED,WHITE,ON)
+searchbox_border_color   = (RED,WHITE,ON)
+position_indicator_color = (BLACK,WHITE,OFF)
+# Menu box
+menubox_color          = (RED,WHITE,ON)
+menubox_border_color   = (RED,WHITE,ON)
+# Menu window
+item_color             = (RED,WHITE,ON)
+item_selected_color    = (BLACK,WHITE,OFF)
+tag_color              = (RED,WHITE,ON)
+tag_selected_color     = (BLACK,WHITE,OFF)
+tag_key_color          = (RED,WHITE,ON)
+tag_key_selected_color = (BLACK,WHITE,OFF)
+check_color            = (RED,WHITE,ON)
+check_selected_color   = (BLACK,WHITE,OFF)
+uarrow_color           = (RED,WHITE,ON)
+darrow_color           = (RED,WHITE,ON)
+# Menu item help
+itemhelp_color         = (RED,WHITE,ON)" > $HOME/.dialogrc
+}
+
+#ATUALIZACAO DOS PACOTES
+apt-get update 
+apt-get upgrade -y
+apt-get install dialog -y
+cores
+
+#SISTEMA DE LEITURA DE DADOS!
+ofuscate_fun () {
+unset resposta
+unset txt
+number=$(expr length $1)
+for ((i=1; i<$number+1; i++)); do
+txt[$i]=$(echo "$1" | cut -b $i)
+if [ "${txt[$i]}" = "." ]; then
+txt[$i]="#"
+else
+ if [ "${txt[$i]}" = "#" ]; then
+txt[$i]="."
+ fi
+fi
+if [ "${txt[$i]}" = "1" ]; then
+txt[$i]="@"
+else
+ if [ "${txt[$i]}" = "@" ]; then
+txt[$i]="1"
+ fi
+fi
+if [ "${txt[$i]}" = "2" ]; then
+txt[$i]="?"
+else
+ if [ "${txt[$i]}" = "?" ]; then
+txt[$i]="2"
+ fi
+fi
+if [ "${txt[$i]}" = "3" ]; then
+txt[$i]="&"
+else
+ if [ "${txt[$i]}" = "&" ]; then
+txt[$i]="3"
+ fi
+fi
+resposta+="${txt[$i]}"
+done
+link_list=$(echo $resposta | rev)
+}
+
+#PROGRESSO DE INSTALACAO!
+gauge () {
+for i in {1..1}; do
+      apt-get update && echo '3'
+      apt-get upgrade -y && echo '7'
+      apt-get install screen -y && echo '12'
+      apt-get install python -y && echo '15'
+      apt-get install lsof -y && echo '17'
+      apt-get install -y python3-pip -y && echo '20'
+      apt-get install nmap -y && echo '25'
+      apt-get install figlet -y && echo '37'
+      apt-get install bc -y && echo '42'
+      apt-get install lynx -y && echo '57'
+      apt-get install curl -y && echo '62'
+      apt-get install zip -y && echo '71'
+      apt-get install apache2 -y && echo '84'
+      sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf && echo '92'
+      service apache2 restart && echo '100'
+      sleep 2s
+done | dialog --title 'Instalando...' --guage 'AGUARDE, INSTALANDO AS DEPENDENCIAS DO ADM-ULTIMATE' 6 80
+}
+
+instala () {
+#COLETA DE DADOS
+key=$(dialog --stdout --nocancel --inputbox 'DIGITE AGORA SUA KEY:' 6 80 )
+[[ "$?" -ne "0" ]] && return 1
+[[ $key = "" ]] && return 1
+#VERIFICANDO A KEY
+cd $HOME
+key[1]=$(echo "$key" | awk -F "?" '{print $2}')
+key[2]=$(echo "$key" | awk -F "?" '{print $1}')
+ofuscate_fun ${key[2]}
+wget -O lista http://$link_list/${key[1]}/lista -o /dev/null
+if [ "$(cat $HOME/lista | grep $link_list/${key[1]})" = "" ]; then
+dialog --title 'Erro!' --msgbox 'A KEY DIGITADA E INCORRETA!' 6 80
+return 1
+fi
+#INICIANDO PROCESSO
+sleep 5s | dialog  --title 'INICIANDO...' --infobox 'AGUARDE INICIANDO INSTALACAO' 4 80
+if [ -d /etc/adm-lite ]; then
+rm -rf /etc/adm-lite
+fi
+mkdir /etc/adm-lite
+cd /etc/adm-lite
+echo "cd /etc/adm-lite && bash ./menu" > /bin/menu
+echo "cd /etc/adm-lite && bash ./menu" > /bin/adm
+chmod +x /bin/menu
+chmod +x /bin/adm
+#INICIANDO DOWLOAD
+while read arq_adm; do
+cd /etc/adm-lite
+wget $arq_adm -o /dev/null
+done < $HOME/lista
+#INICIANDO INSTALACAO DEPENDENCIAS
+gauge
+#READ MENU
+menu=$(dialog --stdout --menu 'ESCOLHA SUA OP��O:' 8 80 0 [1] OpenSSH+Squid [2] Dropbear+Squid [3] OpenVPN+Squid )
+[[ "$?" -ne "0" ]] && return 1
+[[ $menu = "" ]] && return 1
+if [[ "$menu" = "[1]" ]]; then
+echo ""
+echo ""
+source openssh_proxy
+elif [[ "$menu" = "[2]" ]]; then
+echo ""
+echo ""
+source dropbear_proxy
+elif [[ "$menu" = "[3]" ]]; then
+echo ""
+echo ""
+source openvpn_proxy
+fi
+}
+
+loopinst () {
+while true; do
+dialog --title 'AVISO' --yesno 'DESEJA TENTAR INSTALAR NOVAMENTE?' 6 80
+if [[ "$?" = "0" ]]; then
+instala
+else
+break
+fi
+if [[ "$?" = "0" ]]; then
+dialog --title 'Sucesso!' --msgbox 'INSTALACAO CONCLUIDA' 6 80
+echo ""
+echo ""
+break
+fi
+done
+}
+
+rm $(pwd)/$0
+dialog --title 'ADM-ULTIMATE' --msgbox 'INICIANDO INSTALACAO!' 6 80
+instala
+if [[ "$?" = "1" ]]; then
+dialog --title 'Erro!' --msgbox 'INSTALACAO INCOMPLETA' 6 80
+loopinst
+echo ""
+echo ""
+else
+dialog --title 'Sucesso!' --msgbox 'INSTALACAO CONCLUIDA' 6 80
+echo ""
+echo ""
+fi
+clear
