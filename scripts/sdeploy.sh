#!/bin/zsh

# create a map of image names to destination ids
# for example if image name is "plutus-server" the destination id is 125
declare -A image_map
image_map=(
	["plutus-server"]=125
	["plutus-app"]=125
)

sdeploy() {
	image_name=$1
	image_tag=$2
	# image tag is by default latest
	if [[ -z "$image_tag" ]]; then
		image_tag="latest"
	fi

	destination_id=${image_map[$image_name]}

	echo "Building $image_name:$image_tag"

	# check if the build is successful
	# build with: docker-buildx build --no-cache -t $image_name:$image_tag .
	docker-buildx build --no-cache -t $image_name:$image_tag .

	if [[ $? -ne 0 ]]; then
		echo "Error: Build failed."
		return 1
	fi

	echo "Deploying $image_name:$image_tag to LXC $destination_id"

	spullpush $destination_id $image_name $image_tag

	ssh root@serviable "pct exec $destination_id -- /root/deploy/$image_name.sh"
}

spullpush() {
	destination_id=$1
	image_name=$2
	image_tag=$3

	if [[ -z "$destination_id" || -z "$image_name" || -z "$image_tag" ]]; then
		echo "Error: All arguments must have values."
		echo "destination_id: $destination_id, image_name: $image_name, image_tag: $image_tag"
		echo "Usage: spullpush <destination_id> <image_name> <image_tag>"
		return 1
	fi
	ssh root@serviable "bash /etc/custom_scripts/copy_docker_image.sh 124 $destination_id $image_name $image_tag"
}
