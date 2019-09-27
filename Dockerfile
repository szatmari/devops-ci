FROM openjdk:8-jdk-alpine
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/gs-rest-service-0.1.0.jar","--server.port=8088"]
