#!/bin/sh
set -e
echo "set param 1 to help for help"
  
if [ "$1" = "openvpn" ]; then
    if [ ! -d "/openvpn-ca/pki" ]; then
        echo "First time run:"
        if [ -z $2 ]; then
            read -p "Please enter server name (eg. server): " SERVERNAME
        else
          SERVERNAME=$2
        fi
        if [ -z $3 ]; then
            read -p "Please enter server url (server.example.com): " SERVERURL
        else
            SERVERURL=$3
        fi
        cd /openvpn-ca
        ./easyrsa --batch init-pki
        ./easyrsa --batch --req-cn=OpenVPN-CA build-ca nopass
        ./easyrsa --batch --req-cn=$SERVERNAME gen-req $SERVERNAME nopass
        ./easyrsa --batch --req-cn=$SERVERNAME sign-req server $SERVERNAME
        ./easyrsa --batch gen-dh
        /usr/sbin/openvpn --genkey --secret ta.key
        echo "remote $SERVERURL" >> client.conf
    fi

    echo "Starting openvpn server"
    exec /usr/sbin/openvpn /etc/openvpn/server.conf
fi

if [ "$1" = "help" ]; then
    echo "Thank you for using klausmark/openvpn-server"
    echo "To run, you need to run docker with --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun parameters"
    echo ""
    echo "This is an example of how you could run this container:"
    echo "docker container run -d --name openvpn-server --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -p 1194:1194/udp --mount 'source=openvpn-ca,destination=/openvpn-ca' klausmark/openvpn-server:1.0 openvpn servername server.example.com"
    echo ""
    echo "To generate client cert an conf:"
    echo "docker container exec <id> add-client <client name>"
    echo ""
    echo "To get the client config use:"
    echo "docker container exec <id> get-client <client name>"
    echo ""
fi
