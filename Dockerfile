FROM grafana/grafana:8.4.5-ubuntu
LABEL maintainer="DevOps"

COPY ./grafana.ini /etc/grafana/grafana.ini
COPY ./BaltimoreCyberTrustRoot.crt.pem /home/grafana/certs/BaltimoreCyberTrustRoot.crt.pem