FROM debian:9

RUN useradd -ms /bin/bash zomboid && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
            apt-utils \
            build-essential \
            wget \
            curl \
            wget \
            file \
            bzip2 \
            gzip \
            unzip \
            bsdmainutils \
            python \
            util-linux \
            ca-certificates \
            binutils \
            bc \
            util-linux \
            tmux \
            libstdc++6 \
            libstdc++6:i386

USER zomboid

RUN mkdir /home/zomboid/steamcmd && \
    mkdir /home/zomboid/pz-server && \
    cd /home/zomboid/steamcmd && \
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar xzvf steamcmd_linux.tar.gz && \
    ./steamcmd.sh +login anonymous \
                  +force_install_dir /home/zomboid/pz-server \
                  +app_update 380870 validate \
                  +quit

COPY files /

CMD ["/run.sh"]
