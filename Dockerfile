# ==================================
# Stage 1: Build the application
# ==================================
# Use a full JDK image that includes Maven to build the project.
# The 'as builder' syntax names this stage.
FROM openjdk:24-jdk-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and pom.xml first to leverage Docker layer caching
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Build the application, skipping tests for a faster build.
# The result will be a .jar file in the /app/target/ directory.
RUN ./mvnw package -DskipTests

# ==================================
# Stage 2: Create the final image
# ==================================
# Use a valid and minimal JRE-only image for the final application.
# `eclipse-temurin:24-jre-alpine` is an excellent, small, and secure choice.
FROM eclipse-temurin:24-jre-alpine

# Set the working directory
WORKDIR /app

# Copy ONLY the built .jar file from the 'builder' stage into the final image.
# Note the wildcard to match the versioned jar file.
COPY --from=builder /app/target/moderndevbackend-*.jar app.jar

# Expose the port that the Spring Boot application will run on (default is 8080)
EXPOSE 8080

# Set the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]