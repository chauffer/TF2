#!/bin/bash

while true; do
cp -asf /mnt/* /home/steam/steamcmd/tf2/tf
/home/steam/steamcmd/tf2/srcds_run \
	-game tf \
	-autoupdate \
	-console \
	-usercon \
	-steam_dir /home/steam/steamcmd \
  	-steamcmd_script /home/steam/steamcmd/tf2serv.txt \
  	-port ${TTTF2_PORT} \
  	+log on \
  	+sv_pure 2 \
  	+ip "${TTTF2_BIND_IP}" \
  	+map ${TTTF2_MAP} \
  	+maxplayers ${TTTF2_MAXPLAYERS} \
  	+sv_password "${TTTF2_SV_PASSWORD}" \
  	+rcon_password "${TTTF2_RCON_PASSWORD}" \
  	+hostname "${TTTF2_HOSTNAME}"
done
