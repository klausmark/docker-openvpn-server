#!/bin/sh
if [ $# -eq 0 ]
then
    echo "Remember parameter <server-name> <client-name>"
    exit 1
fi

SERVER=$1
CLIENT=$2

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req $SERVER nopass
./easyrsa sign-req server $SERVER
./easyrsa gen-dh
/usr/sbin/openvpn --genkey --secret ta.key

#For each client:
./easyrsa gen-req $CLIENT nopass
./easyrsa sign-req client $CLIENT
