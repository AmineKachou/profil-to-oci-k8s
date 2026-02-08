#!/bin/bash

IMAGE=ghcr.io/aminekachou/web-debian:debian12-v1


docker build -t $IMAGE output/docker
docker push $IMAGE
