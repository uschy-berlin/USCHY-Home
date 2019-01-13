#!/bin/bash
#set -x
# ------------------------------------------------------------------
# [USCHY] 	start_ansible_playbook.sh
#          	Starts an Ansible playbook with the required parameters in USCHY@Home Environment
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

# Globale Variablen
SCRIPTNAME=$(basename $0 .sh)
VERSION=0.1.0
SUBJECT=some-unique-id
ANSIBLE_DIR=/home/ansible/USCHY-Home/ansible/
ANSIBLE_CMD=ansible-playbook
ANSIBLE_PLAYBOOK=
ANSIBLE_PLAYBOOK_VARIABLES=
TAGS=
EXIT_SUCCESS=0
EXIT_FAILURE=1
EXIT_ERROR=2
EXIT_BUG=10
# Variablen für Optionsschalter hier mit Default-Werten vorbelegen
VERBOSE=n
OPTFILE=""

# Funktionen
function usage {
 echo "Usage: $SCRIPTNAME [-h] [-d] -p playbook [-a action] [-v variables] host" >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts ':p:a:v:dh' OPTION ; do
 case $OPTION in
 d) VERBOSE=y
 ;;
 a) TAGS="$OPTARG"
 ;;
 p) ANSIBLE_PLAYBOOK="$OPTARG"
 ;;
 v) ANSIBLE_PLAYBOOK_VARIABLES="$OPTARG"
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
if (( $# < 1 )) ; then
 echo "Mindestens zwei Argumente beim Aufruf übergeben." >&2
 usage $EXIT_ERROR
fi
# Schleife über alle Argumente
for ARG ; do
 if [[ $VERBOSE = y ]] ; then
 echo -n "Argument: "
 fi
 #echo $ARG
 ANSIBLE_PLAYBOOK_VARIABLES=$ANSIBLE_PLAYBOOK_VARIABLES" host="$ARG
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
cd $ANSIBLE_DIR
$ANSIBLE_CMD $ANSIBLE_DIR$ANSIBLE_PLAYBOOK --extra-vars "$ANSIBLE_PLAYBOOK_VARIABLES" --tags $TAGS
# -----------------------------------------------------------------

exit $EXIT_SUCCESS


