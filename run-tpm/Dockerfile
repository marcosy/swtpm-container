FROM docker.io/langbeck/swtpm:0.3.2
RUN apk add netcat-openbsd
COPY load-state.sh /usr/bin/
ENTRYPOINT [ "/usr/bin/load-state.sh" ]
