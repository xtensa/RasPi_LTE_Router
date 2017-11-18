# RasPi_LTE_Router
This repository contains all files required to set up internet gateway on your Raspberry Pi with use of GSM/LTE Huawei E3372s modem. Internet connection is assumed to be provided by GSM modem and local network is assumed to be connected to Raspberry Pi ethernet port. 

## Prerequisites
The following packages should be installed: usb_modeswitch, smstools3, wvdial.

## Included files:

### send_sms.sh
This is simple utility to send SMS text messages. Usage:
```shell
./send_sms.sh <phone> <text>
```

### sms_handler.sh
This is sms handler that receives and parses SMS. If it is received from known number (configured in sms.conf) it is checked to be a known command. Otherwise sms is just forwarded to this number. For use with smstool3 package only.

### start_gateway.sh
ipconfig configuration script.

### start_wvdial.sh
This is wvdial init script. Should be renamed to wvdial and copied to /etc/init.d directory. Will work correctly only on debian based distributions (tested with raspbian only).

### usb_modeswitch.conf
usb_modeswitch configuration file to properly handle E3372 modem. Should be copied to /etc directory.

### wvdial.conf
wvdial configuration utility. Might require modification depending on your service provider. Should be copied to /etc directory.

### sms.conf
Configuration file where you should out your private number used by other scripts.
