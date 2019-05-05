# Source a nice small nginx base image
FROM nginx:alpine
LABEL maintainer="Frans-Jan van Steenbeek <frans-jan@van-steenbeek.net>"

# Install OpenSSL and create the data folder
RUN apk add --no-cache --update openssl && \
  mkdir -p /usr/local/share/cayman/CA

# Add cayman
ADD container.txz /

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman
