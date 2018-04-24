#!/bin/bash
# ------------------------------------------------------------------
# [USCHY]  	kube_setup.sh
#          	This script prepares an Photon Host as Kubernetes 
#			Master or Node
# 
#	DOWNLOAD: scp uschitkowsky@uschysmacbookpro:Documents/GitHub_US
#				CHY-Berlin/USCHY-Home/tools/kube_setup.sh	
#
#	PREREC: setting up Photon Host with photon_basic_setup.sh
#			edit $KUBEPATH/node.json on master
#
#	DOCUMENTATION: https://github.com/vmware/photon/blob/master/
#					docs/kubernetes.md
#
#	INFO: 
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
KUBEPATH=/etc/kubernetes
# Variablen für Optionsschalter hier mit Default-Werten vorbelegen
VERBOSE=n
OPTFILE=""

# Funktionen
function usage {
 echo "Usage: $SCRIPTNAME [-h] [-t master|node -m master_hostname -n node_hostname]" >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
# Die Option -h für Hilfe sollte immer vorhanden sein, die Optionen
# -v und -o sind als Beispiele gedacht. -o hat ein Optionsargument;
# man beachte das auf "o" folgende ":".
while getopts ':t:m:n:h' OPTION ; do
 case $OPTION in
 h) usage $EXIT_SUCCESS
 ;;
 m) MASTERHOSTNAME="$OPTARG"
 ;;
 n) NODEHOSTNAME="$OPTARG"
 ;;
 t) OPTTYPE="$OPTARG"
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

# edit in /etc/kubernetes/config
# Comma separated list of nodes in the etcd cluster
echo KUBE_MASTER="--master=http://"$MASTERHOSTNAME":8080" >> /etc/kubernetes/config
# logging to stderr routes it to the systemd journal
echo KUBE_LOGTOSTDERR="--logtostderr=true" >> /etc/kubernetes/config
# journal message level, 0 is debug
echo KUBE_LOG_LEVEL="--v=0" >> /etc/kubernetes/config
# Should this cluster be allowed to run privileged docker containers
echo KUBE_ALLOW_PRIV="--allow_privileged=false" >> /etc/kubernetes/config
	
if [ "$OPTTYPE" = "master" ]; then
	echo "Installing Kubernetes Master"
	tdnf install kubernetes
	tdnf install iptables
	# Edit /etc/kubernetes/apiserver
	# The address on the local server to listen to.
	echo KUBE_API_ADDRESS="--address=0.0.0.0" >> /etc/kubernetes/apiserver
	# Comma separated list of nodes in the etcd cluster
	echo KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379" >> /etc/kubernetes/apiserver
	# Address range to use for services
	echo KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16" >> /etc/kubernetes/apiserver
	# Add your own
	echo KUBE_API_ARGS="" >> /etc/kubernetes/apiserver
	for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
    	systemctl restart $SERVICES
    	systemctl enable $SERVICES
    	systemctl status $SERVICES
	done
	kubectl create -f $KUBEPATH/node.json
elif [ "$OPTTYPE" = "node" ]; then
	echo "Installing Kubernetes Node"
	tdnf install kubernetes
	tdnf install docker
	# Edit /etc/kubernetes/kubelet 
	# Kubernetes kubelet (node) config
	# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
	echo KUBELET_ADDRESS="--address=0.0.0.0" >> /etc/kubernetes/kubelet 
	# You may leave this blank to use the actual hostname
	echo KUBELET_HOSTNAME="--hostname_override=$NODEHOSTNAME" >> /etc/kubernetes/kubelet
	# location of the api-server
	echo KUBELET_API_SERVER="--api_servers=http://"$MASTERHOSTNAME":8080" >> /etc/kubernetes/kubelet
	# Add your own
	echo KUBELET_ARGS="" >> /etc/kubernetes/kubelet
	for SERVICES in kube-proxy kubelet docker; do 
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
	done
else
	exit $EXIT_ERROR
fi

echo "check the state of nodes on Kubernetes Master Server with kubectl get nodes"

# -----------------------------------------------------------------

exit $EXIT_SUCCESS
