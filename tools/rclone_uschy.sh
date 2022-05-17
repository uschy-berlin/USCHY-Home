#!/usr/bin/bash
# ------------------------------------------------------------------
#  	rclone_uschy.sh
#     	Description
#		runs rclonesync for syncing (nextcloud)data between local user directory and the respective Onedrive
#		this script shall be run by cron of $NC_USER
# 
#	PREREC: rclone config in place for onedrive; sudo for $NC_USER must be possible w/o password
#
#	DOCUMENTATION: 
#
#	INFO: 
#
# ------------------------------------------------------------------

# Globale Variablen
SCRIPTNAME=$(basename $0 .sh)
#User who owns the Webserver
WEBUSER=www-data
#User for whom to run
NC_USER=uschitkowsky
#Base Dir of nextcloud files
NC_BASE=/mnt/data
#Nextcloud Data Dir
NC_DATA=nc_data
#Nextcloud Prog
NC_PROG=nextcloud
LOGDIR=/home/$NC_USER/.config/rclone
LOGFILE=$SCRIPTNAME.log
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
 echo "Usage: $SCRIPTNAME [-h] [-v] [-o arg] file ..." >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts ':o:vh' OPTION ; do
 case $OPTION in
 v) VERBOSE=y
 ;;
 o) OPTFILE="$OPTARG"
 ;;
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
# Eventuelle Tests auf min./max. Anzahl Argumente hier
#if (( $# < 1 )) ; then
# echo "Mindestens ein Argument beim Aufruf übergeben." >&2
# usage $EXIT_ERROR
#fi
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
echo "Starting new Job, at " >> $LOGDIR/$LOGFILE 2>&1 && date >> $LOGDIR/$LOGFILE 2>&1
/usr/local/rclonesync/rclonesync $NC_BASE/$NC_DATA/$NC_USER/files/Dokumente/ onedrive-uschy:/Dokumente >> $LOGDIR/$LOGFILE 2>&1
sudo chown -R $WEBUSER:$WEBUSER $NC_BASE/$NC_DATA/$NC_USER/files/Dokumente/ >> $LOGDIR/$LOGFILE 2>&1
cd $NC_BASE/$NC_PROG
sudo -u $WEBUSER php occ files:scan $NC_USER >> $LOGDIR/$LOGFILE 2>&1
echo "ended Job, at " >> $LOGDIR/$LOGFILE 2>&1 && date >> $LOGDIR/$LOGFILE 2>&1
echo  >> $LOGDIR/$LOGFILE 2>&1

# -----------------------------------------------------------------

exit $EXIT_SUCCESS


