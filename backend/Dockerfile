FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY ${JAR_FILE} mercury-server.jar
EXPOSE 8088
ENTRYPOINT ["java","-jar","/mercury-server.jar"]
