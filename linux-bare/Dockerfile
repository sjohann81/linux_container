FROM docker.io/golang:bullseye AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor openbox tint2 \
    xdg-utils lxterminal hsetroot tigervnc-standalone-server \
    vim geany openssh-client wget curl rsync ca-certificates apulse \
    libpulse0 firefox-esr htop tar xzip gzip bzip2 zip unzip bsdmainutils \
    xterm socat git python3-pip python3-venv python3-tk build-essential && \
    rm -rf /var/lib/apt/lists
    
COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY common/supervisord.conf /etc/
COPY common/menu.xml /etc/xdg/openbox/
RUN echo 'hsetroot -solid "#123456" &' >> /etc/xdg/openbox/autostart

RUN mkdir -p /etc/firefox-esr
RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /etc/firefox-esr/syspref.js

RUN mkdir -p /root/.config/tint2
COPY common/tint2rc /root/.config/tint2/

EXPOSE 8080
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
