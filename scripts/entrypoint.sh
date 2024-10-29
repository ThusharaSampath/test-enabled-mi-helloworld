#!/bin/sh
# entrypoint.sh

# Ensure that TEST_SERVER_PATH is set, or use a default value
: "${TEST_SERVER_PATH:=/default/path}"

echo "TEST_SERVER_PATH: ${TEST_SERVER_PATH}"

# Print a message indicating the start of the build
echo "Running Maven build with test profile..."

# Run the Maven command
mvn clean install -Ptest \
  -DtestServerType=local \
  -DtestServerHost=localhost \
  -DtestServerPort=9008 \
  -DtestServerPath="${TEST_SERVER_PATH}"

# Execute any additional commands passed to the container
exec "$@"
