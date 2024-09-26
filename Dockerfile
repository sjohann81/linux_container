# to build:
# podman build -t labredes .

# to remove:
# podman rmi labredes --force

# to launch a single instance:
# podman run --cap-add NET_ADMIN --privileged -p 8080:8080 labredes
# open a browser and type "localhost:8080"

# to create a network of containers:
# podman network create lab
# podman network ls

# to launch multiple instances (run each command on a separate host terminal):
# podman run --cap-add NET_ADMIN --privileged --network lab -p 8080:8080 labredes
# podman run --cap-add NET_ADMIN --privileged --network lab -p 8081:8080 labredes
# podman run --cap-add NET_ADMIN --privileged --network lab -p 8083:8080 labredes
# open a browser and type "localhost:8080", "localhost:8081" ... to access each container.

# to list running containers
# podman container ls

# to execute a remote command
# podman exec -it <container_name> <command>

# to copy files from the container
# podman cp <container_name>:/container/file/path/ /host/path/target

FROM docker.io/golang:bullseye AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openbox tint2 xdg-utils lxterminal hsetroot tigervnc-standalone-server supervisor && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends vim geany openssh-client wget curl rsync ca-certificates apulse libpulse0 firefox-esr htop tar xzip gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends xterm socat build-essential git && \
    rm -rf /var/lib/apt/lists
    
RUN apt-get update -y && \
    apt-get install -y python3-pip python3-venv python3-tk && \
    rm -rf /var/lib/apt/lists
    
COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY supervisord.conf /etc/
COPY menu.xml /etc/xdg/openbox/
RUN echo 'hsetroot -solid "#123456" &' >> /etc/xdg/openbox/autostart

RUN mkdir -p /etc/firefox-esr
RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /etc/firefox-esr/syspref.js

RUN mkdir -p /root/.config/tint2
COPY tint2rc /root/.config/tint2/

EXPOSE 8080
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord"]
