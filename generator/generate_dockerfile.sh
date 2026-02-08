#!/bin/bash

PROFILE=$1
OUTPUT=output/docker/Dockerfile

DISTRO=$(yq e '.os.distro' $PROFILE)
VERSION=$(yq e '.os.version' $PROFILE)
PACKAGES=$(yq e '.software[]' $PROFILE | tr '\n' ' ')

mkdir -p output/docker

cat <<EOF > $OUTPUT
FROM $DISTRO:$VERSION

RUN apt-get update && \
    apt-get install -y $PACKAGES && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
