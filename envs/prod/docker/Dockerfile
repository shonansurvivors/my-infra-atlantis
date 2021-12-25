FROM ghcr.io/runatlantis/atlantis:v0.17.6

RUN apk --no-cache add libintl && \
      apk --no-cache add --virtual .gettext gettext && \
      cp /usr/bin/envsubst /usr/local/bin/envsubst && \
      apk del .gettext

COPY .aws/config.tmpl /home/atlantis/.aws/
COPY ./docker-entrypoint.sh /usr/local/bin/
