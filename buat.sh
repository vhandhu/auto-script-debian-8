#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo ""
echo " ========================================================== "
echo "                        Membuat Akun                        "
echo " ========================================================== "
echo ""
read -p "         Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	echo "Username [$username] sudah ada!"
	exit 1
else
	read -p "Isikan password akun [$username]: " password
	read -p "Berapa hari akun [$username] aktif: " AKTIF

MYIP=$(wget -qO- ipv4.icanhazip.com)
today="$(date +"%Y-%m-%d")"
	expire=$(date -d "$AKTIF days" +"%Y-%m-%d")
	useradd -M -N -s /bin/false -e $expire $username
	echo $username:$password | chpasswd
clearopensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"

echo -e "\e[0m                                                           "
echo -e "\e[94m =========================================================="
echo -e "\e[0m                                                           "
echo -e "\e[94m           AutoScriptVPS by JAJAN ONLINE                   "
echo -e "\e[94m              Whats App - 08994422537                      "
echo -e "\e[0m                                                   "
echo -e "         Username        :  $username"
echo -e "         Password        :  $password"
echo -e "         Aktif Sampai    :  $expire"
echo -e "\e[0m                                                           "	
echo -e "         Host / IP       :  "$MYIP
echo -e "         Port OpenSSH    :  "$opensshport
echo -e "         Port Dropbear   :  "$dropbearport
echo -e "         Port SSL        :  "$stunnel4port
echo -e "         Port Squid      :  "$squidport
echo -e "         Port OpenVPN    :  "$openvpnport
echo -e "         OpenVPN Client  :  $MYIP/client.ovpn"
echo -e "                                                               "
echo -e "\e[94m ==========================================================\e[0m"
fi