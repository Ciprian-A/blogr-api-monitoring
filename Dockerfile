FROM alpine:latest AS builder
RUN apk add --no-cache gettext
COPY prometheus.yml /etc/prometheus/prometheus.template
ARG BACKEND_INTERNAL_URL
ENV BACKEND_INTERNAL_URL=${BACKEND_INTERNAL_URL}
RUN envsubst < /etc/prometheus/prometheus.template > /etc/prometheus/prometheus.yml

FROM prom/prometheus:latest
COPY --from=builder /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml

ENTRYPOINT [ "/bin/prometheus" ]
CMD [ "--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus", "--web.console.libraries=/usr/share/prometheus/console_libraries", "--web.console.templates=/usr/share/prometheus/consoles", "--web.enable-remote-write-receiver" ]