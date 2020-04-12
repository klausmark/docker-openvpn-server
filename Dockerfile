FROM alpine:latest
RUN mkdir /openvpn-ca && \
    apk add --no-cache openvpn openssl && \
    cd /openvpn-ca
COPY openvpn-ca /openvpn-ca
VOLUME /openvpn-ca
COPY server.conf /etc/openvpn
EXPOSE 1194/udp
CMD /usr/sbin/openvpn /etc/openvpn/server.conf
# docker container run -d --name openvpn-server --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -p 1194:1194/udp --mount 'source=openvpn-ca,destination=/openvpn-ca' openvpn
