# Source a nice small nginx base image
FROM nginx:alpine
LABEL maintainer="Frans-Jan van Steenbeek <frans-jan@van-steenbeek.net>"

# Install OpenSSL and create the data folder
RUN apk add --no-cache --update openssl && \
  mkdir -p /usr/local/share/cayman/CA

# Copy files
COPY cayman /usr/local/bin/cayman
COPY cayman.conf openssl.conf /usr/local/share/cayman/
COPY nginx.conf /etc/nginx/conf.d/cayman.conf

# Make cayman.conf container-proof
RUN echo >> /usr/local/share/cayman/cayman.conf && \
  echo '# Docker overrides' >> /usr/local/share/cayman/cayman.conf && \
  echo 'PDIR="/usr/local/share/cayman/CA/"' >> /usr/local/share/cayman/cayman.conf && \
  echo 'CONF="/usr/local/share/cayman/openssl.conf"' >> /usr/local/share/cayman/cayman.conf && \
  ln -s /usr/local/share/cayman/cayman.conf /usr/local/bin/cayman.conf

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman
