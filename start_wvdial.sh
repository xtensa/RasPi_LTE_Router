#!/bin/bash

### BEGIN INIT INFO
# Provides:          wvdiald
# Required-Start:    $syslog $network $time smstools
# Required-Stop:     $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: E-LAB wvdial service
# Description:       E-LAB wvdial service
### END INIT INFO

. /lib/lsb/init-functions
. /root/gsm_conf/sms.conf

SEND_SMS="/root/gsm_conf/send_sms.sh"
TIMEOUT=10

log () {
#	echo $1
	log_daemon_msg "$1 "
	echo
}

error () {
#	echo $1
	$SEND_SMS $PHONE $1
	log_failure_msg $1
}


case "$1" in
start)
	log "Starting E-LAB wvdiald..."
#	if ps ax | grep "/usr/sbin/pppd" | grep -v -q "grep"; then
#		log "pppd is already running. Exitting..."
#		log_end_msg 0
#		exit 0
#	fi

	# first we need to wait while modem is present
	tries=0	
	while :; do
		tries=$((tries+1))
		if [ $tries -gt $TIMEOUT ] ; then
			error "RasPI boot failure: modem not initialized"
			log_end_msg 1
			exit 1
		fi

		lsusb | grep "12d1:155f" > /dev/null
		retval=$?
		if [ $retval -ne 0 ] ; then
			sleep 1
			log "Waiting for modem $tries seconds..."
		else
			log "Modem present"
			break
		fi
	done

	wvdial Defaults > /var/log/wvdial.log 2>&1 &
	PID=$!

	tries=0	
	while :; do
		tries=$((tries+1))
		if [ $tries -gt $TIMEOUT ] ; then
			error "RasPI boot failure: waiting for ppp0 too long"
			log_end_msg 1
			exit 1
		fi

		ifconfig | grep "ppp0" > /dev/null
		retval=$?
		if [ $retval -ne 0 ] ; then
			sleep 1
			log "Waiting for ppp0 $tries seconds..."
		else
			log "ppp0 is up"
			break
		fi
	done

	log_end_msg 0
	;;
stop)
	killall wvdial > /dev/null 2>&1
	log_end_msg 0
	;;
restart|force-reload)
        $0 stop
        $0 start
        ;;
*)
        echo "ERROR: unknown parameter $1"
	log_end_msg 1
        exit 1
	;;
esac
