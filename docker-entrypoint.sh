#!/bin/sh
set -e

echo "Thank you for using klausmark/openvpn-server"
echo "To run, you need to run docker with --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun parameters"
echo ""
echo "This is an example of how you could run this container:"
echo "docker container run -d --name openvpn-server --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -p 1194:1194/udp --mount 'source=openvpn-ca,destination=/openvpn-ca' klausmark/openvpn-server:1.0"
echo ""
echo "To generate client cert use:"
echo ""
echo ""

if [ ! -d "/openvpn-ca/pki" ]; then
    echo "First time run:"
    read -p "Please enter server name (eg. server): " SERVERNAME
    read -p "Please enter server url (server.example.com): " SERVERURL
    cd /openvpn-ca
    ./easyrsa --batch init-pki
    ./easyrsa --batch build-ca nopass
    ./easyrsa --batch gen-req $SERVERNAME nopass
    ./easyrsa --batch sign-req server $SERVERNAME
    ./easyrsa --batch gen-dh
    /usr/sbin/openvpn --genkey --secret ta.key
fi

if [ "$1" = "openvpn" ]; then
    echo "Starting openvpn server"
    exec /usr/sbin/openvpn /etc/openvpn/server.conf
fi

exec "$@"
