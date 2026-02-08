FROM debian:12-slim

RUN apt-get update &&     apt-get install -y nginx curl  &&     apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
