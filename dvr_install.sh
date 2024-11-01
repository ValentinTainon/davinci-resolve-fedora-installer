#!/usr/bin/bash

###############################################################################
################################### VARS ######################################
###############################################################################
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET_CLR="\e[0m"

###############################################################################
################################# FUNCTIONS ###################################
###############################################################################

check_cmd() {
    if [ $? == 0 ]; then
        echo -e "[$GREEN OK $RESET_CLR]"
    else
        echo -e "[$RED ERROR $RESET_CLR]"
        exit
    fi
}

###############################################################################
############################# START OF SCRIPT #################################
###############################################################################

if [ "$(whoami)" != "root" ]; then
    echo -e "[$RED ERROR $RESET_CLR] Utilisateur non autorisé. Veuillez relancer le script en tant que root."
    exit 1
fi

echo -e "${CYAN}DAVINCI RESOLVE$RESET_CLR"

if ! dnf list intel-opencl 2>&1 | grep -qi "installed"; then
    echo -ne "Installation of ${CYAN}intel-opencl${RESET_CLR}: "
    sudo dnf update >/dev/null && sudo dnf install intel-opencl >/dev/null
    check_cmd
fi

if ls ./DaVinci_Resolve_*_Linux/DaVinci_Resolve_*_Linux.run >/dev/null 2>&1; then
    read -p "Installation file detected, continue? [Y/n] " response

    if [ "$response" != "n" ]; then
        sudo chmod +x ./DaVinci_Resolve_*_Linux/DaVinci_Resolve_*_Linux.run

        if [ ! -d "/opt/resolve" ]; then
            echo -n "Installing DAVINCI RESOLVE: "
        else
            echo -n "DAVINCI RESOLVE Update: "
        fi
        SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_*_Linux/DaVinci_Resolve_*_Linux.run
        check_cmd
    fi
fi

# Removing problematic libraries
if ls /opt/resolve/libs/libglib-2.0.so* >/dev/null 2>&1; then
    echo -n "Removing libglib-2.0.so library: "
    sudo rm /opt/resolve/libs/libglib-2.0.so*
    check_cmd
fi

if ls /opt/resolve/libs/libgio-2.0.so* >/dev/null 2>&1; then
    echo -n "Removing libgio-2.0.so library: "
    sudo rm /opt/resolve/libs/libgio-2.0.so*
    check_cmd
fi

if ls /opt/resolve/libs/libgmodule-2.0.so* >/dev/null 2>&1; then
    echo -n "Removing libgmodule-2.0.so library: "
    sudo rm /opt/resolve/libs/libgmodule-2.0.so*
    check_cmd
fi

if ls /opt/resolve/libs/libgobject-2.0.so* >/dev/null 2>&1; then
    echo -n "Removing libgobject-2.0.so library: "
    sudo rm /opt/resolve/libs/libgobject-2.0.so*
    check_cmd
fi

echo "Done."

###############################################################################
############################### END OF SCRIPT #################################
###############################################################################
