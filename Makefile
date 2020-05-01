
up:
	rsync ${LOCAL_PATH} root@${SERVER_IP}:${REMOTE_PATH} -av --progress

d:
	docker build -t chauffer/tf2 .

rd:
	make up
	ssh root@${SERVER_IP} "cd ${REMOTE_PATH}; make d"

rdfix:
	ssh root@${SERVER_IP} "docker rm -f tttf2 || true"
	ssh root@${SERVER_IP} "docker system prune -a -f"

ssh:
	ssh root@${SERVER_IP}

run:
	docker rm -f tttf2 || true
	docker run -ti \
	-p 27015:27015 \
	--user=root \
	-p 27015:27015/udp \
	-v /root/git/tttf2/mnt:/mnt \
	--name=tttf2 \
	--entrypoint=bash \
	chauffer/tf2