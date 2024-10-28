# 1. Create a directory structure
mkdir -p wso2mi/bin

# 2. Copy your WSO2 MI pack to the wso2mi directory
# Replace with your actual WSO2 MI pack location
cp -r /path/to/your/wso2mi-pack/* wso2mi/

# 3. Ensure the micro-integrator script is executable
chmod +x wso2mi/bin/micro-integrator.sh

# 4. Build the Docker image
docker build -t wso2mi-test-runner .

# 5. Run tests using the container
docker run --rm \
    -v "$(pwd)":/app \
    -v "$(pwd)/wso2mi":/wso2mi \
    wso2mi-test-runner

# 6. Check test results
ls -l target/surefire-reports