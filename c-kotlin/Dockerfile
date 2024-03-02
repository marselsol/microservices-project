FROM maven:3.8.4-openjdk-17-slim as build
WORKDIR /workspace/app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /workspace/app/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","app.jar"]