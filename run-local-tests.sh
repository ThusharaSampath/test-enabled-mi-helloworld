#!/bin/bash

# Configuration
WSO2_MI_PATH="/Users/wso2/.m2/repository/org/wso2/ei/wso2mi/4.3.0/wso2mi-4.3.0"  # Update this path
IMAGE_NAME="thusharasampath/wso2-mi-test:arm64"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up test environment...${NC}"

# Create directories
mkdir -p volume/wso2mi/wso2mi-4.3.0

# Copy WSO2 MI pack
echo -e "${GREEN}Copying WSO2 MI pack...${NC}"
if [ -d "$WSO2_MI_PATH" ]; then
    cp -r $WSO2_MI_PATH/* volume/wso2mi/wso2mi-4.3.0
    # chmod +x wso2mi/bin/micro-integrator.sh
else
    echo -e "${RED}Error: WSO2 MI pack not found at $WSO2_MI_PATH${NC}"
    exit 1
fi

# # Build Docker image
# echo -e "${GREEN}Building Docker image...${NC}"
# docker build -t $IMAGE_NAME .

# Run tests
echo -e "${GREEN}Running tests...${NC}"
docker run --rm \
    -v "$(pwd)":/app \
    -v ~/.m2/repository:/app/?/.m2/repository:rw \
    $IMAGE_NAME

# Check exit status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Tests completed successfully!${NC}"
else
    echo -e "${RED}Tests failed!${NC}"
fi

# Show test results location
echo -e "${GREEN}Test results available at:${NC}"
echo "$(pwd)/target/surefire-reports"