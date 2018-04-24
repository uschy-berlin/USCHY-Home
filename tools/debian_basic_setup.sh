#!/bin/bash
# ------------------------------------------------------------------
# [USCHY]  	debian_basic_setup.sh
#          	This script prepares the following things on a fresh
#          	debian installation
#			enabling docker on boot
#			enabling ssh for root with certificates
#			installing vmware Tools
# 
#	Download: scp uschitkowsky@uschysmacbookpro:Documents/Gi
#			tHub_USCHY-Berlin/USCHY-Home/tools/debian
#			_basic_setup.sh	
#
#	PREREC: 
#	setting up Windows Server with openssh https://github.co
#              m/PowerShell/Win32-OpenSSH/releases/
#       install desc https://winscp.net/eng/docs/guide_windows_
#              openssh_server
#
#	INFO:
#	LVM commands are commented because not every system will 
#	use this
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

#installing patches,open-vm-tools and cifs
apt-get update && apt-get upgrade
apt-get install -y cifs-utils open-vm-tools

# setting up git on this machine
apt-get install git git-core
git clone https://github.com/uschy-berlin/USCHY-Home.git

# SSH für Root mit Zertifikat
echo "enabling ssh"
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# setting up ssh certificate for root getting from USCHY12
echo "getting ssh certificate"
scp uschitkowsky@192.168.136.11:.ssh/authorized_keys /root/.ssh

# getting several data for mounting centarl FS
scp uschy12:masters/linux/debian-setup/cifspasswd /etc/
scp uschy12:masters/linux/debian-setup/fstab /tmp
cat /tmp/fstab >> /etc/fstab
chmod 600 /etc/cifspasswd
mount -a

# setting up LVM
# pvcreate /dev/sdb
# vgcreate DATA-VG /dev/sdb
# lvcreate -n myData-LV -L 10G DATA-VG
# mkfs -t ext4 /dev/DATA-VG/DATA-LV
# mkdir /data
# einfuegen in /etc/fstab die Zeile /dev/DATA-VG/DATA-LV /data ext4 defaults 0 0

# DOCKER AKTIVIEREN
echo "activating docker"
scp uschitkowsky@uschysmacbookpro:Documents/GitHub_USCHY-Berlin/USCHY-Home/tools/backports.list /etc/apt/sources.list.d
apt-get update
apt-get purge "lxc-docker*"
apt-get purge "docker.io*"
apt-get install apt-transport-https ca-certificates gnupg2
apt-key adv \
       --keyserver hkp://ha.pool.sks-keyservers.net:80 \
       --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-engine
service docker start

# -----------------------------------------------------------------

exit $EXIT_SUCCESS
