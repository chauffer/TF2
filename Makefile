
up:
	rsync ${LOCAL_PATH} root@${SERVER_IP}:${REMOTE_PATH} -av --progress

d:
	docker build -t tttf2/tttf2 .

rd:
	make up
	ssh root@${SERVER_IP} "cd ${REMOTE_PATH}; make d"

rdfix:
	ssh root@${SERVER_IP} "docker system prune -f"