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
    xterm socat git python3-pip python3-venv python3-tk python3 gperf patchutils \
    build-essential flex bison libgmp3-dev libmpc-dev libmpfr-dev bc libexpat-dev \
    autoconf automake autotools-dev texinfo libncurses5-dev gawk libtool zlib1g-dev \
    usbutils bash-completion dfu-util ghdl gtkwave && \
    rm -rf /var/lib/apt/lists

RUN wget http://beru.univ-brest.fr/svn/CHEDDAR/releases/Cheddar-3.3-Linux-bin.tar.gz && \
    tar -zxvf Cheddar-3.3-Linux-bin.tar.gz && \
    rm Cheddar-3.3-Linux-bin.tar.gz && \
    mkdir /usr/local/cheddar && \
    mv Cheddar-3.3-Linux-bin /usr/local/cheddar && \
    echo 'export PATH=$PATH:/usr/local/cheddar/Cheddar-3.3-Linux-bin' >> /root/.bashrc && \
    echo 'export CHEDDAR_INSTALL_PATH=/usr/local/cheddar/Cheddar-3.3-Linux-bin/' >> /root/.bashrc

RUN git clone https://github.com/qemu/qemu && \
    cd qemu && \
    ./configure --target-list=riscv32-softmmu,riscv64-softmmu,arm-softmmu,aarch64-softmmu && \
    make && \
    make install && \
    cd ../ && \
    rm -rf qemu

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
    ../../source/binutils-2.43/configure --prefix=/usr/local/riscv64-unknown-elf/gcc-14.2.0 \
        --target=riscv64-unknown-elf --disable-multilib && \
    make -j2 all && \
    make install-strip && \
    cd ../../build && \
    mkdir gcc-14.2.0 && \
    cd gcc-14.2.0 && \
    ../../source/gcc-14.2.0/configure --prefix=/usr/local/riscv64-unknown-elf/gcc-14.2.0 \
        --target=riscv64-unknown-elf --enable-languages=c,c++ --without-headers \
        --disable-libssp --disable-shared --disable-multilib && \
    make -j2 all-gcc && \
    make install-strip-gcc && \
    cd ../../ && \
    rm -rf source/ build/ download/ install/ && \
    echo 'export PATH=$PATH:/usr/local/riscv64-unknown-elf/gcc-14.2.0/bin' >> /root/.bashrc

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
