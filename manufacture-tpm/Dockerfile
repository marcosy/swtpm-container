FROM docker.io/langbeck/swtpm:0.3.2
RUN apk add netcat-openbsd
COPY create-state.sh /usr/bin/
ENTRYPOINT [ "/usr/bin/create-state.sh" ]
