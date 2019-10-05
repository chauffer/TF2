#!/bin/bash

echo "hostname "${SV_HOSTNAME} >> /home/steam/steamcmd/tf2/tf/cfg/autoexec.cfg
echo "rcon_password "${RCON_PASSWORD} >> /home/steam/steamcmd/tf2/tf/cfg/autoexec.cfg

while true; do
cp -asf /mnt/* /home/steam/steamcmd/tf2/tf
/home/steam/steamcmd/tf2/srcds_run -game tf -autoupdate -console -usercon -steam_dir /home/steam/steamcmd -steamcmd_script /home/steam/steamcmd/tf2serv.txt -port ${SV_PORT} +log on +sv_pure 2 +ip "0.0.0.0" +map ${MAP} +maxplayers ${SV_MAXPLAYERS}
done
