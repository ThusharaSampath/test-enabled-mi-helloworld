#!/bin/bash

# Configuration
DOCKER_REPO="thusharasampath"
IMAGE_NAME="wso2-mi-test"
TAG="amd64"  # Change this as needed
# TAG="arm64"  # Change this as needed

# Full image name
FULL_IMAGE_NAME="$DOCKER_REPO/$IMAGE_NAME:$TAG"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Creating Dockerfile...${NC}"

# Create Dockerfile
cat << EOF > Dockerfile
FROM eclipse-temurin:11-jdk

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

ENV TEST_SERVER_PATH=""

# set user
# USER 10015

ENTRYPOINT ["sh", "-c", "mvn clean install -Ptest -DtestServerType=local -DtestServerHost=localhost -DtestServerPort=9008 -DtestServerPath=${TEST_SERVER_PATH}"]
EOF

# Build Docker image
echo -e "${GREEN}Building Docker image: $FULL_IMAGE_NAME${NC}"
docker build --platform linux/$TAG -t $FULL_IMAGE_NAME .

# Push to Docker Hub
echo -e "${GREEN}Pushing image to Docker Hub...${NC}"
docker push $FULL_IMAGE_NAME

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully built and pushed: $FULL_IMAGE_NAME${NC}"
else
    echo -e "${RED}Failed to build or push image${NC}"
    exit 1
fi