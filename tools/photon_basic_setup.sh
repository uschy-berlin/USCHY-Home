#!/bin/bash
# ------------------------------------------------------------------
# [USCHY]  	photon_basic_setup
#          	This script prepares the following things on a fresh
#          	photon installation
#		   		Keyboard set to german
#		   		# man and pager set up
#				enabling docker on boot
#				enabling ssh for root with certificates
#				installing vmware Tools & Network Manager
#				setting DNS Server
#				clearing machine id to generate unique DHCP requests
# 
#	Download: scp uschitkowsky@uschysmacbookpro:Documents/GitHub_US
#				CHY-Berlin/USCHY-Home/tools/photon_basic_setup.sh	
#
#	PREREC: setting up Windows Server with openssh https://github.co
#              m/PowerShell/Win32-OpenSSH/releases/
#           install desc https://winscp.net/eng/docs/guide_windows_
#              openssh_server
#
#	INFO: packet Manager on Photon is called tdnf (yum compatible)
#
# ------------------------------------------------------------------

# Globale Variablen
SCRIPTNAME=$(basename $0 .sh)
VERSION=0.1.0
SUBJECT=some-unique-id
EXIT_SUCCESS=0
EXIT_FAILURE=1
EXIT_ERROR=2
EXIT_BUG=10
# Variablen für Optionsschalter hier mit Default-Werten vorbelegen
VERBOSE=n
OPTFILE=""

# Funktionen
function usage {
 echo "Usage: $SCRIPTNAME [-h]" >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts ':o:vh' OPTION ; do
 case $OPTION in
 h) usage $EXIT_SUCCESS
 ;;
 \?) echo "Unbekannte Option \"-$OPTARG\"." >&2
 usage $EXIT_ERROR
 ;;
 :) echo "Option \"-$OPTARG\" benötigt ein Argument." >&2
 usage $EXIT_ERROR
 ;;
 *) echo "Dies kann eigentlich gar nicht passiert sein..."
>&2
 usage $EXIT_BUG
 ;;
 esac
done
# Verbrauchte Argumente überspringen
shift $(( OPTIND - 1 ))
# Schleife über alle Argumente
for ARG ; do
 if [[ $VERBOSE = y ]] ; then
 echo -n "Argument: "
 fi
 echo $ARG
done

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "Script is already running"
   exit
fi
trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Body --------------------------------------------------------
#  SCRIPT LOGIC GOES HERE

# update the distro
tdnf distro-sync

# SETTING KEYBOARD TO GERMAN
echo "setting keyboard to german"
localectl set-keymap de-latin1-nodeadkeys

# SETTING MAN AND PAGER
#mkdir /var/cache/man
#mandb
#echo 'export PAGER=less' >> ~/.profile

# DOCKER AKTIVIEREN
echo "activating docker"
systemctl start docker   # docker starten
systemctl enable docker  # enable docker on boot 

# SSH für Root mit Zertifikat
echo "enabling ssh"
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# setting DNS Server for USCHY@Home
echo "setting DNS resolver"
RESOLV_CONF="/etc/resolv.conf"
#AUSGABE_TAIL="`cat "${RESOLV_CONF}" | grep "nameserver" | tail -1`"
#cat ${RESOLV_CONF} | sed "/${AUSGABE_TAIL}/G" | sed "s/^$/nameserver 192.168.136.11/" > ${RESOLV_CONF}
echo "nameserver 192.168.136.11" >> ${RESOLV_CONF}

# installing vmware tools
echo "installing vmware tools & NetwokManager"
tdnf install open-vm-tools
tdnf install NetworkManager

# setting up ssh certificate for root getting from USCHY12
echo "getting ssh certificate"
scp uschitkowsky@192.168.136.11:.ssh/authorized_keys /root/.ssh

# clearing machine id to generate unique DHCP requests
echo "clearing machine ID"
echo -n > /etc/machine-id

echo
echo "Please set the desired Hostname in /etc/hostname"
echo

# -----------------------------------------------------------------

exit $EXIT_SUCCESS
