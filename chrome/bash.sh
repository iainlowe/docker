function chrome() {
	# add flags for proxy if passed
	local proxy=
	local map=
	local args=$@
	
	docker run -d \
		--net host \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=unix$DISPLAY \
		-v $HOME/Downloads:/root/Downloads \
		-v $HOME/.config/google-chrome:/data \
		-v /dev/shm:/dev/shm \
		-v /etc/hosts:/etc/hosts \
		--device /dev/snd \
		--device /dev/video0 \
		--group-add audio \
		--group-add video \
		--name chrome \
		ilowe/chrome --user-data-dir=/data --force-device-scale-factor=1 \
		--proxy-server="$proxy" --host-resolver-rules="$map" "$args"
}
