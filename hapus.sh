#!/bin/bash
# ========================================
#           Original Script By            
#   Jajan Online - Whats App 08994422537  
# ========================================

echo ""
echo " ========================================================== "
echo "                        Hapus Akun                        "
echo " ========================================================== "
echo ""
read -p "         Hapus user : " username

if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna
        echo -e "User $Pengguna telah dihapus."
else
        echo -e "GAGAL: User $Pengguna tidak ada."
fi
