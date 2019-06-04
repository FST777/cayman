#####################
# Builder container #
#####################

FROM nginx:alpine AS builder

# Set up filesystem
RUN mkdir -p /tmp/root/usr/local/share/cayman/CA
COPY cayman /tmp/root/usr/local/bin/
COPY cayman.conf openssl.conf /tmp/root/usr/local/etc/
COPY nginx.conf /tmp/root/etc/nginx/conf.d/

# Adjust cayman.conf
RUN sed -i 's|^PDIR=.*$|PDIR="/usr/local/share/cayman/CA/"|' /tmp/root/usr/local/etc/cayman.conf && \
sed -i 's|^CONF=.*$|CONF="/usr/local/etc/openssl.conf"|' /tmp/root/usr/local/etc/cayman.conf && \
echo >> /tmp/root/usr/local/etc/cayman.conf && \
echo "# Persistent overrides can be put here:" >> /tmp/root/usr/local/etc/cayman.conf && \
echo "[ -r /usr/local/share/cayman/cayman.conf ] && source /usr/local/share/cayman/cayman.conf" >> /tmp/root/usr/local/etc/cayman.conf

####################
# Cayman container #
####################

FROM nginx:alpine
LABEL maintainer="Frans-Jan van Steenbeek <frans-jan@van-steenbeek.net>"

# Install OpenSSL
RUN apk add --no-cache --update openssl

# Add cayman
COPY --from=builder /tmp/root/ /

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman
