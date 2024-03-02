FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /workspace/app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /workspace/app/target/clojure-microservice-1.0-SNAPSHOT-jar-with-dependencies.jar /app/clojure-microservice.jar
EXPOSE 8090
CMD ["java", "-cp", "/app/clojure-microservice.jar", "clojure.main", "-m", "com.example.core"]