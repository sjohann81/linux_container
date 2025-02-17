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
    xterm socat git python3-pip python3-venv python3-tk \
    build-essential flex bison libgmp3-dev libmpc-dev libmpfr-dev \
    autoconf texinfo libncurses5-dev gawk libtool zlib1g-dev \
    usbutils bash-completion dfu-util && \
    rm -rf /var/lib/apt/lists

RUN mkdir source && \
    mkdir build && \
    mkdir install && \
    mkdir download && \
    cd download && \
    wget -c ftp://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.gz && \
    wget -c ftp://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz && \
    cd ../source && \
    tar -zxvf ../download/binutils-2.43.tar.gz && \
    tar -zxvf ../download/gcc-14.2.0.tar.gz && \    
    cd ../build && \
    mkdir binutils-2.43 && \
    cd binutils-2.43 && \
    ../../source/binutils-2.43/configure --prefix=/usr/local/arm-none-eabi/gcc-14.2.0 \
        --target=arm-none-eabi --disable-multilib && \
    make -j2 all && \
    make install-strip && \
    cd ../../build && \
    mkdir gcc-14.2.0 && \
    cd gcc-14.2.0 && \
    ../../source/gcc-14.2.0/configure --prefix=/usr/local/arm-none-eabi/gcc-14.2.0 \
        --target=arm-none-eabi --enable-languages=c,c++ --without-headers \
        --disable-libssp --disable-shared --disable-multilib && \
    make -j2 all-gcc && \
    make install-strip-gcc && \
    cd ../../ && \
    rm -rf source/ build/ download/ install/ && \
    echo 'export PATH=$PATH:/usr/local/arm-none-eabi/gcc-14.2.0/bin' >> /root/.bashrc

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
