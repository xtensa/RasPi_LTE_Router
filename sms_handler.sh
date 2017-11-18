#!/bin/bash


TOOLS_DIR=/root/gsm_conf
. ${TOOLS_DIR}/functions.sh

# this file should contain variable $PHONE with your phone number
. ${TOOLS_DIR}/sms.conf

FWD_NUMBER=$PHONE
timestamp=`date "+%Y%m%d-%H%M%S"`
SMS_PROG=${TOOLS_DIR}/send.sms.sh

#run this script only when a message was received.
if [ "$1" != "RECEIVED" ]; then exit; fi;
 
#Extract data from the SMS file
SENDER=`formail -zx From: < $2`
TEXT=`formail -I "" <$2 | sed -e"1d"`

TMPINFILE=/tmp/sms_in_${SENDER}_${timestamp}.txt
TMPOUTFILE=/tmp/sms_out_${SENDER}_${timestamp}.txt



if [ "$SENDER" = "$FWD_NUMBER" ] ; then
	case "$TEXT" in
	"cmd#1")
		get_system_status > $TMPINFILE
	;;
	"cmd#2")
		sudo /etc/init.d/wvdiald restart >> $TMPINFILE 2>&1
		echo "Result: $?" >> $TMPINFILE
	;;
 	"cmd#3")
		sudo /etc/init.d/openvpn restart >> $TMPINFILE 2>&1
		echo "Result: $?" >> $TMPINFILE
	;; 
 	"cmd#4")
		sudo /etc/init.d/sms3 restart >> $TMPINFILE 2>&1
		echo "Result: $?" >> $TMPINFILE
	;; 
	"cmd#5")
		sudo reboot
	;;
	*)
		echo "Wrong CMD. Available CMD list:" > $TMPINFILE
		echo "cmd#1 - net status" >> $TMPINFILE
		echo "cmd#2 - ppp0 restart" >> $TMPINFILE
		echo "cmd#3 - openvpn restart" >> $TMPINFILE
		echo "cmd#4 - sms3 restart" >> $TMPINFILE
		echo "cmd#5 - reboot" >> $TMPINFILE
	;;
	esac
else
	echo "SMS from: $SENDER" > $TMPINFILE
	echo "Text: $TEXT" >> $TMPINFILE
fi


echo "To: $FWD_NUMBER" > $TMPOUTFILE
echo "" >> $TMPOUTFILE
cat $TMPINFILE >> $TMPOUTFILE
cp $TMPOUTFILE /var/spool/sms/outgoing/



