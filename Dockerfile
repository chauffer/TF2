FROM debian:10-slim

RUN set -x && \
	dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y lib32z1 lib32ncurses-dev lib32gcc1 lib32stdc++6 wget curl libcurl3-gnutls:i386 ca-certificates --no-install-recommends && \
	adduser steam && \
	mkdir -p /home/steam/steamcmd && \
	wget -O /tmp/steamcmd.tar.gz http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
	tar -zxvf /tmp/steamcmd.tar.gz -C /home/steam/steamcmd && \
	chown steam:steam /home/steam/ -R && \
	rm -rf /tmp/* /var/lib/apt/lists/* 

COPY tf2serv.txt /home/steam/steamcmd/tf2serv.txt
COPY startserver.sh /home/steam/steamcmd/startserver.sh
COPY bin/* /usr/local/bin/

RUN set -x && \
	/home/steam/steamcmd/steamcmd.sh +runscript /home/steam/steamcmd/tf2serv.txt && \
	update_metamod && \
	update_sourcemod && \
	rm -rfv /tmp/*


ENV TTTF2_MAP="arena_badlands" \
	TTTF2_RCON_PASSWORD="changeme" \
	TTTF2_SV_PASSWORD="toctoc" \
	TTTF2_MAXPLAYERS="32" \
	TTTF2_BIND_IP="0.0.0.0" \
	TTTF2_PORT="27015" \
	TTTF2_HOSTNAME="TTTF2.com Development Server" \
	TTTF2_FASTDL="https://fastdl.tttf2.com/"


EXPOSE 27015 27015/udp

ENTRYPOINT ["/home/steam/steamcmd/startserver.sh"]