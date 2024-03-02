FROM openjdk:17-slim
RUN apt-get update && \
    apt-get install -y maven
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests
EXPOSE 8098
CMD ["java", "-jar", "target/groovy-microservice-0.0.1-SNAPSHOT.jar"]
