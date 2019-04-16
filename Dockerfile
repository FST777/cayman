FROM nginx:alpine

RUN apk add --no-cache --update openssl
COPY cayman /usr/local/bin/cayman

RUN mkdir -p /usr/local/share/cayman/CA
COPY cayman.conf /usr/local/share/cayman/cayman.conf
COPY cayman-openssl.cnf /usr/local/share/cayman/openssl.cnf
RUN echo >> /usr/local/share/cayman/cayman.conf
RUN echo '# Docker overrides' >> /usr/local/share/cayman/cayman.conf
RUN echo 'PDIR="/usr/local/share/cayman/CA/"' >> /usr/local/share/cayman/cayman.conf
RUN echo 'CONF="/usr/local/share/cayman/openssl.cnf"' >> /usr/local/share/cayman/cayman.conf

RUN ln -s /usr/local/share/cayman/cayman.conf /usr/local/bin/cayman.conf
COPY cayman.ngx.conf /etc/nginx/conf.d/cayman.ngx.conf

VOLUME /usr/local/share/cayman
