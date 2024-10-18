FROM debian:12

RUN apt update && apt install -y net-tools procps most iproute2  iputils-ping dnsutils

RUN apt install -y bind9 dnsutils rsyslog

RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^OPTIONS=.*/OPTIONS="-u bind -4"/' /etc/default/named

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]



