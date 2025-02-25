. ~/.node.env
docker build --build-arg VER=$VER -t armoniax/node:$VER -f ./Dockerfile .
