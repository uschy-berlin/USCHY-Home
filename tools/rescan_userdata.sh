#!/bin/bash
# ------------------------------------------------------------------
# [USCHY] 	rescan_userdata.sh
#               Scannt die Daten eines Users erneut und schriebt 
#               sie in die DB
# 
#	DOWNLOAD: 	
#
#	PREREC: 
#
#	DOCUMENTATION: 
#
#	INFO: 
#
# ------------------------------------------------------------------

# start debuging
#set -x

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
 echo "Usage: $SCRIPTNAME [-h] [-v] -u user" >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts 'u:vh' OPTION ; do
 case $OPTION in
 v) VERBOSE=y
 ;;
 u) OPTFILE="$OPTARG"
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
if (( $# < 0 )) ; then
 echo "Mindestens ein Argument beim Aufruf übergeben." >&2
 usage $EXIT_ERROR
fi
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

# -----------------------------------------------------------------

cd /var/www/nextcloud
sudo -u www-data php occ file:scan $OPTFILE -v
exit $EXIT_SUCCESS


