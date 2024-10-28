FROM eclipse-temurin:11-jdk

# Install Maven
RUN apt-get update &&     apt-get install -y maven &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

ENV TEST_SERVER_PATH=""

# set user
# USER 10015

ENTRYPOINT ["sh", "-c", "mvn clean install -Ptest -DtestServerType=local -DtestServerHost=localhost -DtestServerPort=9008 -DtestServerPath="]
