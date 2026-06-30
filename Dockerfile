FROM prom/prometheus:latest

USER root

RUN apk add --no-cache gettext

COPY prometheus.yml /etc/prometheus/prometheus.template

RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'envsubst < /etc/prometheus/prometheus.template > /etc/prometheus/prometheus.yml' >> /entrypoint.sh && \
    echo 'exec /bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/usr/share/prometheus/console_libraries --web.console.templates=/usr/share/prometheus/consoles --web.enable-remote-write-receiver' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER nobody

ENTRYPOINT ["/entrypoint.sh"]