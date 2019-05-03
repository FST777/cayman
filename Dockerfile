# Source a nice small nginx base image
FROM nginx:alpine
LABEL maintainer="Frans-Jan van Steenbeek <frans-jan@van-steenbeek.net>"

# Install OpenSSL and create the data folder
RUN apk add --no-cache --update openssl && \
  mkdir -p /usr/local/share/cayman/CA && \
  mkdir /usr/local/etc

# Copy files
COPY cayman /usr/local/bin/cayman
COPY cayman.conf openssl.conf /usr/local/etc/
COPY nginx.conf /etc/nginx/conf.d/cayman.conf

# Make cayman.conf container-proof
RUN echo >> /usr/local/etc/cayman.conf && \
  echo '# Docker overrides' >> /usr/local/etc/cayman.conf && \
  echo 'PDIR="/usr/local/share/cayman/CA/"' >> /usr/local/etc/cayman.conf && \
  echo 'CONF="/usr/local/etc/openssl.conf"' >> /usr/local/etc/cayman.conf && \
  echo >> /usr/local/etc/cayman.conf && \
  echo '# Persistent overrides can be put here:' >> /usr/local/etc/cayman.conf && \
  echo '[ -r /usr/local/share/cayman/cayman.conf ] && source /usr/local/share/cayman/cayman.conf' >> /usr/local/etc/cayman.conf

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman
