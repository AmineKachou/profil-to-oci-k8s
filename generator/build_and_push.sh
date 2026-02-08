#!/bin/bash

IMAGE=ghcr.io/AmineKachou/web-debian:debian12-v1


docker build -t $IMAGE output/docker
docker push $IMAGE
