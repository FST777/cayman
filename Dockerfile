# Source a nice small nginx base image
FROM nginx:alpine

# Install OpenSSL and cayman
RUN apk add --no-cache --update openssl
COPY cayman /usr/local/bin/cayman

# Set up /usr/local/share/cayman
RUN mkdir -p /usr/local/share/cayman/CA
COPY cayman.conf /usr/local/share/cayman/cayman.conf
COPY openssl.conf /usr/local/share/cayman/openssl.conf

# Make cayman.conf container-proof
RUN echo >> /usr/local/share/cayman/cayman.conf
RUN echo '# Docker overrides' >> /usr/local/share/cayman/cayman.conf
RUN echo 'PDIR="/usr/local/share/cayman/CA/"' >> /usr/local/share/cayman/cayman.conf
RUN echo 'CONF="/usr/local/share/cayman/openssl.conf"' >> /usr/local/share/cayman/cayman.conf

# Other config files
RUN ln -s /usr/local/share/cayman/cayman.conf /usr/local/bin/cayman.conf
COPY nginx.conf /etc/nginx/conf.d/cayman.conf

# Make /usr/local/share/cayman a volume
VOLUME /usr/local/share/cayman
