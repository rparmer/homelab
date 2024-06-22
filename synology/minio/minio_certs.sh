cp -f /usr/syno/etc/certificate/_archive/$(cat /usr/syno/etc/certificate/_archive/DEFAULT)/privkey.pem /volume1/docker/minio/.certs/private.key && \
cp -f /usr/syno/etc/certificate/_archive/$(cat /usr/syno/etc/certificate/_archive/DEFAULT)/fullchain.pem /volume1/docker/minio/.certs/public.crt
