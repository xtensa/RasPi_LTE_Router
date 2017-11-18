#!/bin/bash

timestamp=`date "+%Y%m%d-%H%M%S"`
#exit 0

if [ $# -ne 2 ] ; then
	echo "ERROR: missing parameter. Usage:"
	echo "        $0 <phone> <text>"
	exit 1
fi
FWD_NUMBER=$1
TEXT=$2
TMPINFILE=/tmp/sms_in_${timestamp}.txt
TMPOUTFILE=/tmp/sms_out_${timestamp}.txt


echo "To: $FWD_NUMBER" > $TMPOUTFILE
echo "" >> $TMPOUTFILE
echo "$TEXT" >> $TMPOUTFILE
cp $TMPOUTFILE /var/spool/sms/outgoing/


