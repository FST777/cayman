#####################
# Builder container #
#####################

FROM docker.io/library/alpine:latest AS builder

# Set up filesystem
RUN mkdir -p /tmp/root/usr/local/bin
RUN mkdir -p /tmp/root/usr/local/etc
RUN mkdir -p /tmp/root/usr/local/share/cayman/CA
RUN apk -p /tmp/root add --initdb
RUN cp -r /etc/apk/keys /etc/apk/repositories /tmp/root/etc/apk
RUN apk -p /tmp/root add openssl lighttpd
RUN touch /tmp/root/var/www/localhost/htdocs/index.html

COPY cayman /tmp/root/usr/local/bin/
COPY cayman.conf openssl.conf /tmp/root/usr/local/etc/
COPY lighttpd.conf /tmp/root/etc/lighttpd/
COPY handler.sh /tmp/root/usr/local/bin/

# Adjust cayman.conf
RUN sed -i 's|^PDIR=.*$|PDIR="/usr/local/share/cayman/CA/"|' /tmp/root/usr/local/etc/cayman.conf && \
sed -i 's|^CONF=.*$|CONF="/usr/local/etc/openssl.conf"|' /tmp/root/usr/local/etc/cayman.conf && \
echo >> /tmp/root/usr/local/etc/cayman.conf && \
echo "# Persistent overrides can be put here:" >> /tmp/root/usr/local/etc/cayman.conf && \
echo "[ -r /usr/local/share/cayman/cayman.conf ] && source /usr/local/share/cayman/cayman.conf" >> /tmp/root/usr/local/etc/cayman.conf

####################
# Cayman container #
####################

FROM scratch
LABEL maintainer="Frans-Jan van Steenbeek <frans-jan@van-steenbeek.net>"

# Add cayman
COPY --from=builder /tmp/root/ /

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman

# Declare which ports we serve
EXPOSE 80 8080

# Run Lighttpd
CMD /usr/sbin/lighttpd -Df /etc/lighttpd/lighttpd.conf
