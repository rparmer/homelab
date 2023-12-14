FROM alpine:latest

# Install curl and jq
RUN apk add --no-cache curl jq

ADD update_ip.sh /root/

ENTRYPOINT [ "/bin/sh", "-c", "/root/update_ip.sh" ]
