# Multi-stage Dockerfile for building and running the Spring Boot app

# Build stage: use Maven + JDK to build the fat jar
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /workspace/app

# Copy Maven wrapper and settings first to leverage layer caching
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN chmod +x mvnw

# Copy source and build
COPY src ./src
RUN ./mvnw -B -DskipTests package

# Run stage: small JRE image
FROM eclipse-temurin:17-jre
WORKDIR /app

# Install curl and postgresql client for healthchecks and wait script
RUN apt-get update && apt-get install -y curl postgresql-client && rm -rf /var/lib/apt/lists/*

# Copy the built jar from the builder stage
COPY --from=builder /workspace/app/target/*.jar app.jar

# Copy helper script to wait for DB and make it executable
COPY wait-for-db.sh ./wait-for-db.sh
RUN chmod +x ./wait-for-db.sh

EXPOSE 8080

ENTRYPOINT ["/app/wait-for-db.sh"]
