FROM alpine:latest
RUN mkdir /openvpn-ca && \
    apk add --no-cache openvpn openssl && \
    cd /openvpn-ca
COPY openvpn-ca /openvpn-ca
VOLUME /openvpn-ca
COPY server.conf /etc/openvpn
COPY docker-entrypoint.sh /usr/local/bin/
COPY add-client /usr/local/bin
COPY get-client /usr/local/bin

RUN ln -s /usr/local/bin/docker-entrypoint.sh /

EXPOSE 1194/udp
CMD ["openvpn"]
ENTRYPOINT ["docker-entrypoint.sh"]
# docker container run -d --name openvpn-server --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun -p 1194:1194/udp --mount 'source=openvpn-ca,destination=/openvpn-ca' openvpn
