#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo ""
echo " ========================================================== "
echo "                        Tambah Masa Aktif                   "
echo " ========================================================== "
echo ""
read -p "         Isikan username: " username
read -p "         Isikan password akun [$username]: " password
read -p "         Berapa hari akun [$username] aktif: " AKTIF
userdel $username
useradd -e `date -d "$AKTIF days" +"%Y-%m-%d"` -s /bin/false -M $username
exp="$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$password\n$password\n"|passwd $username &> /dev/null

MYIP=$(wget -qO- ipv4.icanhazip.com)
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
	
echo -e ""
echo -e " ===================== Informasi Akun ===================== "
echo -e " Host           : "$MYIP                                     
echo -e " Port OpenSSH   : "$opensshport                                        
echo -e " Port Dropbear  : "$dropbearport                             
echo -e " Port Squid     : "$squidport                                 
echo -e " Config OpenVPN : $MYIP:3128/client.ovpn                    "         
echo -e " Username       : $username                                 "
echo -e " Password       : $password                                 "
echo -e " ========================================================== "
echo -e " Aktif Sampai   : $exp                                  "
echo -e " ========================================================== "
echo -e "                     Original Script by                     "
echo -e "            Jajan Online - Whats App 08994422537            "
echo -e " ========================================================== "
echo -e ""
else
echo "Username [$username] belum terdaftar!"
	exit 1
fi