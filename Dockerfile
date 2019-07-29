FROM ubuntu:bionic

ARG username
ARG password

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y lib32stdc++6 lib32gcc1 wget && \
    useradd -m steam

USER steam

RUN mkdir /home/steam/steamcmd /home/steam/arma3

WORKDIR /home/steam/steamcmd

RUN wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf - && \
    ./steamcmd.sh +login $username $password +force_install_dir /home/steam/arma3 +app_update 233780 validate +quit

USER root

RUN apt-get remove --purge -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

USER steam

EXPOSE 2344 2345/tcp 2302:2305

WORKDIR /home/steam/arma3

CMD ["./arma3server"]
