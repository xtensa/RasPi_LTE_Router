#!/bin/sh

# This is simple iptabes configuration to setup internet gateway. 
# It is intended to use if you have internet connection on ppp0 interface 
# and OpenVPN connection to you remote network on tun0 interface.


PATH=/usr/sbin:/sbin:/bin:/usr/bin

#
# delete all existing rules.
#
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X


iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Always accept incoming loopback and local traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -j ACCEPT


# Allow established connections, and those not coming from the outside
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i ppp0 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow incoming connections from OpenVPN
iptables -A INPUT -i tun0 -j ACCEPT

# Allow outgoing connections from the local network.
iptables -A FORWARD -i eth0 -o ppp0 -j ACCEPT

# Masquerade all outgoing connections.
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE

# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward

