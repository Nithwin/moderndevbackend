# Stage 1: Build the application with JDK 24
# Use a valid OpenJDK 24 image. This image is officially published and stable.
FROM openjdk:24-jdk-slim as build

# Install Maven in the container.
# This ensures that both JDK and Maven are present for the build.
RUN apt-get update && apt-get install -y maven

# Set the working directory inside the container.
WORKDIR /app

# Copy the entire project into the container.
COPY . .

# Build the project, skipping tests to make the build faster.
RUN mvn clean package -DskipTests

# Stage 2: Create the final production-ready image
# Use a smaller JRE-only image for the final application, based on JDK 24.
# `openjdk:24-jre-slim` is an official and reliable image.
FROM openjdk:24-jre-slim

# Set the volume for temporary files.
VOLUME /tmp

# Copy the built JAR file from the 'build' stage into this new, smaller image.
# The JAR file is typically found in the target/ directory for Maven.
COPY --from=build /app/target/*.jar app.jar

# Expose the default port for a Spring Boot application.
EXPOSE 8080

# Define the command to run the application when the container starts.
ENTRYPOINT ["java","-jar","/app.jar"]