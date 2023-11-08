#!/bin/bash
#25/01/2021
clear
clear
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
SCPdir="/etc/VPS-MX"
 SCPfrm="${SCPdir}/herramientas" && [[ ! -d ${SCPfrm} ]] && exit
 SCPinst="${SCPdir}/protocolos"&& [[ ! -d ${SCPinst} ]] && exit
BARRA1="\e[0;31m--------------------------------------------------------------------\e[0m"

fun_bar () {
#==comando a ejecutar==
comando="$1"
#==interfas==
in=' ['
en=' ] '
full_in="➛"
full_en='100%'
bar=(────────────────────
═───────────────────
▇═──────────────────
▇▇═─────────────────
═▇▇═────────────────
─═▇▇═───────────────
──═▇▇═──────────────
───═▇▇═─────────────
────═▇▇═────────────
─────═▇▇═───────────
──────═▇▇═──────────
───────═▇▇═─────────
────────═▇▇═────────
─────────═▇▇═───────
──────────═▇▇═──────
───────────═▇▇═─────
────────────═▇▇═────
─────────────═▇▇═───
──────────────═▇▇═──
───────────────═▇▇═─
────────────────═▇▇═
─────────────────═▇▇
──────────────────═▇
───────────────────═
──────────────────═▇
─────────────────═▇▇
────────────────═▇▇═
───────────────═▇▇═─
──────────────═▇▇═──
─────────────═▇▇═───
────────────═▇▇═────
───────────═▇▇═─────
──────────═▇▇═──────
─────────═▇▇═───────
────────═▇▇═────────
───────═▇▇═─────────
──────═▇▇═──────────
─────═▇▇═───────────
────═▇▇═────────────
───═▇▇═─────────────
──═▇▇═──────────────
─═▇▇═───────────────
═▇▇═────────────────
▇▇═─────────────────
▇═──────────────────
═───────────────────
────────────────────);
#==color==
in="\033[1;33m$in\033[0m"
en="\033[1;33m$en\033[0m"
full_in="\033[1;31m$full_in"
full_en="\033[1;32m$full_en\033[0m"

 _=$(
$comando > /dev/null 2>&1
) & > /dev/null
pid=$!
while [[ -d /proc/$pid ]]; do
	for i in "${bar[@]}"; do
		echo -ne "\r $in"
		echo -ne "ESPERE $en $in \033[1;31m$i"
		echo -ne " $en"
		sleep 0.1
	done
done
echo -e " $full_in $full_en"
sleep 0.1s
}

selection_fun () {
 local selection="null"
 local range
 for((i=0; i<=$1; i++)); do range[$i]="$i "; done
 while [[ ! $(echo ${range[*]}|grep -w "$selection") ]]; do
 echo -ne "\033[1;37m$(fun_trans " ► Selecione una Opcion"): " >&2
 read selection
 tput cuu1 >&2 && tput dl1 >&2
 done
 echo $selection
 }
 
 mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
}
 
 trojan() {

[[ $(mportas|grep trojan|head -1) ]] && {
# INICIO STUNNEL ACTIVO
msg -bar 
echo -e "${cor[2]} Trojan-Go ACTIVO en Puertos: $trojanports "
msg -bar
echo -e " \033[0;35m[\033[0;36m1\033[0;35m] \033[0;34m<\033[0;33m Adicionar Usuario ( Menu TROJAN )  \033[0;32m(#OFICIAL by @ChumoGH)" 
echo -e " \033[0;35m[\033[0;36m2\033[0;35m] \033[0;34m<\033[0;33m Cerrar Puerto (s)" 
msg -bar   
echo -ne " ESCOJE: "; read lang
case $lang in
1)
source <(curl -sSL https://www.dropbox.com/s/vogt0tyaqg0gee1/trojango.sh);;
2)
source <(curl -sL https://git.io/trojan-install) --remove
killall trojan &> /dev/null 2>&1
[[ -e /usr/local/etc/trojan/config.json ]] && rm -f /usr/local/etc/trojan /usr/local/etc/trojan/config.json
[[ -e /bin/troj.sh ]] && rm -f /bin/troj.sh
clear
echo -e "\033[1;37m  Desinstalacion Completa \033[0m"
echo -e "\033[1;31mINSTALACION FINALIZADA - PRESIONE ENTER\033[0m"
read -p " "
;;
0)
return 0
;;
esac
#FIN VERIFICA STUNNEL4 ACTIVO 
} || {
wget -q https://www.dropbox.com/s/vogt0tyaqg0gee1/trojango.sh; chmod +x trojango.sh; ./trojango.sh
rm -f trojango.sh
return 0
}
}
web_min () {
 [[ -e /etc/webmin/miniserv.conf ]] && {
 echo -e "$barra\n\033[1;32m  REMOVENDO WEBMIN\n$barra"
 fun_bar "apt-get remove webmin -y"
 echo -e "$barra\n\033[1;32m  Webmin Removido\n$barra"
 [[ -e /etc/webmin/miniserv.conf ]] && rm /etc/webmin/miniserv.conf
 return 0
 }
echo -e " \033[1;36mInstalling Webmin, aguarde:"
fun_bar "wget https://sourceforge.net/projects/webadmin/files/webmin/1.881/webmin_1.881_all.deb"
fun_bar "dpkg --install webmin_1.881_all.deb"
fun_bar "apt-get -y -f install"
rm /root/webmin_1.881_all.deb > /dev/null 2>&1
service webmin restart > /dev/null 2>&1 
echo -e "${barra}\n  Accede via web usando el enlace: https;//$(wget -qO- ifconfig.me):10000\n${barra}"
echo -e " Procedimento Concluido\n${barra}"
return 0
}
msg -bar3
msg -bar3
msg -bar3
 msg -bar
 msg -tit
# echo -e "        \e[91m\e[43mINSTALADOR DE V2RAY\e[0m"
# msg -bar
 ## INSTALADOR

on="\033[1;32m[ON]" && off="\033[1;31m[OFF]"
#shadowsocksr |ON| |OF|
shad=$(ps ax |grep /usr/local/shadowsocksr|grep -v grep)
[[ $shad != "" ]] && shad="\033[1;32m[ON]" || shad="\033[1;31m[OFF]"
#shadowsocks-r |ON| |OF|
valuest=$(ps ax |grep /etc/shadowsocks-r|grep -v grep)
[[ $valuest != "" ]] && valuest="\033[1;32m[ON]" || valuest="\033[1;31m[OFF]"
#pide="$(pid_inst python)" || pide="$(pid_inst python3)"
pyt="\033[1;36m[MULT]" || pyt="\033[1;32m[MULT]"
pidproxy=$(ps x | grep -w  "proxy-color.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy ]] && pow="$on" || pow="$off"
[[ $(ps x | grep valuest | grep -v grep | awk '{print $1}') ]] && obfs=$on || obfs=$off
[[ $(ps x | grep obfs-serv | grep -v grep | awk '{print $1}') ]] && obfs=$on || obfs=$off
[[ $(ps x | grep dropbear | grep -v grep | awk '{print $1}') ]] && dropbear=$on || dropbear=$off
[[ $(ps x | grep openvpn | grep -v grep | awk '{print $1}') ]] && openvpn=$on || openvpn=$off
[[ $(ps x | grep squid | grep -v grep | awk '{print $1}') ]] && squid=$on || squid=$off
[[ $(ps x | grep stunnel4 | grep -v grep | awk '{print $1}') ]] && ssl=$on || ssl=$off
[[ $(ps x | grep sslh | grep -v grep | awk '{print $1}') ]] && sslh=$on || sslh=$off
[[ $(ps x | grep v2ray | grep -v grep | awk '{print $1}') ]] && v2ray=$on || v2ray=$off
[[ $(ps x | grep pid_badvpn | grep -v grep | awk '{print $1}') ]] && utils=$on || utils=$off
#export -f fun_eth
#FUNCOES
funcao_addcores () {
if [ "$1" = "0" ]; then
cor[$2]="\033[0m"
elif [ "$1" = "1" ]; then
cor[$2]="\033[1;31m"
elif [ "$1" = "2" ]; then
cor[$2]="\033[1;32m"
elif [ "$1" = "3" ]; then
cor[$2]="\033[1;33m"
elif [ "$1" = "4" ]; then
cor[$2]="\033[1;34m"
elif [ "$1" = "5" ]; then
cor[$2]="\033[1;35m"
elif [ "$1" = "6" ]; then
cor[$2]="\033[1;36m"
elif [ "$1" = "7" ]; then
cor[$2]="\033[1;37m"
fi
}

[[ -e $_cores ]] && {
_cont="0"
while read _cor; do
funcao_addcores ${_cor} ${_cont}
_cont=$(($_cont + 1))
done < $_cores
} || {
cor[0]="\033[0m"
cor[1]="\033[1;34m"
cor[2]="\033[1;32m"
cor[3]="\033[1;37m"
cor[4]="\033[1;36m"
cor[5]="\033[1;33m"
cor[6]="\033[1;35m"
}
unset squid
unset dropbear
unset openvpn
unset stunel
unset shadow
unset telegran
unset socks
unset gettun
unset tcpbypass
unset webminn
unset ddos
unset v2ray
#xclash=`if netstat -tunlp | grep clash 1> /dev/null 2> /dev/null; then
#echo -e "\033[1;32m[ON] "
#else
#echo -e "\033[1;31m[OFF]"
#fi`;
slowssh=$(ps x | grep "slowdns-ssh"|grep -v grep > /dev/null && echo -e "\033[1;32m◉ " || echo -e "\033[1;31m○ ")
slowpid=$(ps x | grep -w "slowdns" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $slowpid ]] && P1="\033[0;32m[ON] " || P1="\033[1;31m[OFF]"
[[ -e /etc/squid3/squid.conf ]] && squid="\033[0;32m[ON] " || squid="\033[1;31m[OFF]"
[[ -e /etc/squid/squid.conf ]] && squid="\033[0;32m[ON] " || squid="\033[1;31m[OFF]"
[[ $(mportas|grep dropbear|head -1) ]] && dropbear="\033[0;32m[ON] " || dropbear="\033[1;31m[OFF]"
#[[ -e /etc/default/dropbear ]] 
[[ -e /etc/openvpn/server.conf ]] && openvpn="\033[0;32m[ON] " || openvpn="\033[1;31m[OFF]"
[[ $(mportas|grep stunnel4|head -1) ]] && stunel="\033[1;32m[ON] " || stunel="\033[1;31m[OFF]"
[[ -e /etc/shadowsocks.json ]] && shadow="\033[1;32m[ON]  " || shadow="\033[1;33m ( #BETA )"
[[ "$(ps x | grep "ultimatebot" | grep -v "grep")" != "" ]] && telegran="\033[1;32m[ON]"
[[ -e /bin/ejecutar/PortPD.log ]] && socks="\033[1;32m[\033[0;34mSPY\033[1;32m]" || socks="\033[1;31m[OFF]"
[[ -e /etc/adm-lite/edbypass ]] && tcpbypass="\033[1;32m[ON]" || tcpbypass="\033[1;31m[OFF]"
[[ -e /etc/webmin/miniserv.conf ]] && webminn="\033[1;32m[ON]" || webminn="\033[1;31m[OFF]"
[[ -e /usr/local/x-ui/bin/config.json ]] && v2ui="\033[1;32m[ON]" || v2ui="\033[1;31m[OFF]"
[[ -e /usr/local/etc/trojan/config.json ]] && troj="\033[1;32m[ON]" || troj="\033[1;31m[OFF]"
#[[ -e /root/.config/clash/config.yaml  ]] && xclash="\033[1;32m[ON] " || xclash="\033[1;31m[OFF]"
[[ -e /etc/default/sslh ]] && sslh="\033[1;32m[ON] " || sslh="\033[1;31m[OFF]"
[[ -e /usr/local/ddos/ddos.conf ]] && ddos="\033[1;32m[ON]"
#[[ -e $(mportas|grep v2ray|head -1) ]] && v2ray="\033[1;32m[ON]" || v2ray="\033[1;31m[OFF]"
ssssrr=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
#ip=$(curl ifconfig.me) > /dev/null
[[ ! -z "${ssssrr}" ]] && cc="\033[1;32m" || cc="\033[1;31m"
user_info=$(cd /usr/local/shadowsocksr &> /dev/null  && python mujson_mgr.py -l )
user_total=$(echo "${user_info}"|wc -l)" Cts"
[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg || source <(curl -sSL https://raw.githubusercontent.com/ChumoGH/ChumoGH-Script/master/msg-bar/msg)
#export -f fun_bar
msg -ama "      \e[1;33m|\e[1;43m \e[1;31mMENÚ DE INSTALACIONES \e[0m\e[1;33m| "
msg -bar
echo -e "\e[1;32m [1] \e[1;31m ➬  \e[1;37mSHADOWSOCKS-R   $valuest "
echo -e "\e[1;32m [2] \e[1;31m ➬  \e[1;37mX-UI WEB        $v2ui"
echo -e "\e[1;32m [3] \e[1;31m ➬  \e[1;37mTROJAN          $tojanss"
echo -e "\e[1;32m [4] \e[1;31m ➬  \e[1;37mWEBMIN          $webminn"
echo -e "\e[1;32m [5] \e[1;31m ➬  \e[1;37mNEXTCLOUD "
echo -e "\e[1;32m [6] \e[1;31m ➬  \e[1;37mPLEX MEDIA "
echo -e "\e[1;32m [7] \e[1;31m ➬  \e[1;37mCPANEL BETA "
echo -e "\e[1;32m [8] \e[1;31m ➬  \e[1;37mDRUPAL "
echo -e "\e[1;32m [9] \e[1;31m ➬  \e[1;37mSOCKS PYTHON "
echo -e "\e[1;32m [10] \e[1;31m ➬  \e[1;37mBOT-WHATSAPP "
echo -e "\e[1;32m [11] \e[1;31m ➬  \e[1;37mSNELL "
echo -e "\e[1;32m [12] \e[1;31m ➬  \e[1;37mTUNNELVPS "
echo -e "\e[1;32m [13] \e[1;31m ➬  \e[1;37mRENIEC "
echo -e "\e[1;32m [14] \e[1;31m ➬  \e[1;37mSERVER WEB "
echo -e "\e[1;32m [0] \e[1;31m ➬  \e[97m\033[1;41m VOLVER \033[1;37m"
msg -bar
selection=$(selection_fun 17)
case $selection in
1)${SCPinst}/Shadowsocks-R.sh ;;
#2)${SCPinst}/Shadowsocks-libev.sh ;;
#2)${SCPinst}/shadowsocks.sh ;;
2)
bash <(curl -Ls https://www.dropbox.com/s/qi2xp6hinepkbfr/x-ui.sh) ;;
3)trojan ;;
4)source <(curl -sSL https://www.dropbox.com/s/t27jtv2jj2x4s5d/webmin.sh) ;;
5)
source <(curl -sSL https://www.dropbox.com/s/lru636qpplbu58k/Nextcloud.sh)
read -p " Enter";;
#bash <(curl -Ls https://www.dropbox.com/s/nedn4ylzq1a1v0p/extras.sh) ;;
6)
source <(curl -sSL https://www.dropbox.com/s/agj4lefawykchok/plexmedia.sh)
read -p " Enter";;
#bash <(curl -Ls https://www.dropbox.com/s/9uyqy8qi1dvy8qn/extras.sh) ;;
7)
source <(curl -sSL https://www.dropbox.com/s/vzdteckp49dni6c/ws-java.sh) ;;
8)
source <(curl -sSL https://www.dropbox.com/s/bxw9ew3gorb109c/drupal.sh) ;;
9)
source <(curl -sSL https://www.dropbox.com/s/sjo0j8uc2vuy6cu/sockspy.sh) ;;
10)
source <(curl -sSL https://www.dropbox.com/s/fj9hwenlnisnl3p/botwp.sh) ;;
11)
source <(curl -sSL https://www.dropbox.com/s/eiviyad4e6navoq/snell.sh) ;;
12)
source <(curl -sSL https://www.dropbox.com/s/wu80eb02eev0d0c/tunnelvps.sh) ;;
13)
source <(curl -sSL https://www.dropbox.com/s/bemenfbfyna1b4d/reniec.sh) ;;
14)
source <(curl -sSL https://www.dropbox.com/s/gbp6jwt2b0t6o6p/vpsweb.sh) ;;
 0)exit;;
 esac 