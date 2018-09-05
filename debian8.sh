#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

# Initializing Var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
country=ID
state=Jakarta
locality=Jakarta
organization=Jajan.Online
organizationalunit=IT
commonname=Jajan.Online.com
email=jajan.online@gmail.com

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# Update
apt-get update

# Install Essential Packages
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

echo "clear" >> .bashrc
echo 'echo -e "Selamat datang di server $HOSTNAME"' >> .bashrc
echo 'echo -e "Jajan Online, Whats app 08994422537"' >> .bashrc
echo 'echo -e "Ketik menu untuk menampilkan daftar perintah"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<h1><center>Jajan_Online, Whats app 08994422537</center></h1>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/8 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/iptables-restore"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 142"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 442
connect = 127.0.0.1:443

END

#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# Install DDOS Deflate
cd
apt-get -y install dnsutils dsniff
wget "https://github.com/vhandhu/auto-script-debian-8/raw/master/ddos-deflate-master.zip"
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
cd
rm -rf ddos-deflate-master.zip

# Banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

# XML Parser
cd
apt-get -y --force-yes -f install libxml-parser-perl

# Install Screenfetch
apt-get -y install lsb-release scrot
wget -O screenfetch "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/screenfetch"
chmod +x screenfetch

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/menu.sh"
wget -O buat "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/buat.sh"
wget -O tambah "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/tambah.sh"
wget -O hapus "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/cek.sh"
wget -O member "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/member.sh"
wget -O expired "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/expired.sh"
wget -O reboot "https://raw.githubusercontent.com/vhandhu/auto-script-debian-8/master/reboot.sh"

# AutoReboot Tools
echo "10 0 * * * root /usr/local/bin/reboot" > /etc/cron.d/reboot
echo "0 1 * * * root expired" > /etc/cron.d/expired
echo "*0 */2 * * * root clearcache" > /etc/cron.d/clearcache

# Set Permissions
chmod +x menu
chmod +x buat
chmod +x tambah
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x expired
chmod +x reboot


# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service stunnel4 restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# grep ports 
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
nginxport="$(netstat -nlpt | grep -i nginx| grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

# Info
clear
echo -e ""
echo -e "\e[94m =========================================================="
echo -e "\e[0m                                                            "
echo -e "\e[94m           AutoScriptVPS by JAJAN ONLINE                   "
echo -e "\e[94m              Whats App - 08994422537                      "
echo -e "\e[94m                    Services                               "
echo -e "\e[94m                                                           "
echo -e "\e[94m    OpenSSH        :   "$opensshport
echo -e "\e[94m    Dropbear       :   "$dropbearport
echo -e "\e[94m    SSL            :   "$stunnel4port
echo -e "\e[94m    OpenVPN        :   "$openvpnport
echo -e "\e[94m    Port Squid     :   "$squidport
echo -e "\e[94m    Nginx          :   "$nginxport
echo -e "\e[94m                                                           "
echo -e "\e[94m              Other Features Included                      "
echo -e "\e[94m                                                           "
echo -e "\e[94m    Timezone       :   Asia/Jakarta (GMT +7)               "
echo -e "\e[94m    Webmin         :   http://$MYIP:10000/                 "
echo -e "\e[94m    IPV6           :   [OFF]                               "
echo -e "\e[94m    Cron Scheduler :   [ON]                                "
echo -e "\e[94m    Fail2Ban       :   [ON]                                "
echo -e "\e[94m    DDOS Deflate   :   [ON]                                "
echo -e "\e[94m    LibXML Parser  :   {ON]                                "
echo -e "\e[0m                                                            "
echo -e "\e[94m =========================================================="
echo -e "\e[0m                                                            "
cd
rm -f /root/debian8.sh
