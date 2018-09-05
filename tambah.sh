#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo -e "\e[0m                                                   "
echo -e "\e[94m=========================================================="
echo -e "\e[0m                                                   "
read -p "         Username       :  " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "         Day Extend     : " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expires_On=$(($Today + $Days_Detailed))
Expired=$(date -u --date="1970-01-01 $Expires_On sec GMT" +%Y/%m/%d)
Expired_Display=$(date -u --date="1970-01-01 $Expires_On sec GMT" '+%d %b %Y')
passwd -u $User
usermod -e  $Expired $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
clear
echo -e "\e[0m                                                   "
echo -e "\e[94m=========================================================="
echo -e "\e[0m                                                   "
echo -e "         Username        :  $User"
echo -e "         Days Added      :  $Days Days"
echo -e "         Expires on      :  $Expired_Display"
echo -e "\e[0m                                                   "
echo -e "\e[94m==========================================================\e[0m"
else
clear
echo -e "\e[0m                                                   "
echo -e "\e[94m=========================================================="
echo -e "\e[0m                                                   "
echo -e "\e[93m              Username Doesnt Exist               "
echo -e "\e[0m                                                   "
echo -e "\e[94m==========================================================\e[0m"

fi