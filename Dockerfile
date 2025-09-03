# Stage 1: Build the application
# Use a Maven image that includes JDK 17 to build the project.
FROM maven:3.8.2-openjdk-17 AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy the pom.xml and the rest of the project files.
COPY pom.xml .
COPY src ./src

# Build the project, skipping tests to make the build faster.
RUN mvn clean package -DskipTests

# Stage 2: Create the final production-ready image
# Use a smaller JRE-only image for the final application.
FROM openjdk:17-jre-slim

# Set the volume for temporary files.
VOLUME /tmp

# Copy the built JAR file from the 'build' stage into this new image.
# The JAR file is typically found in the target/ directory for Maven.
COPY --from=build /app/target/*.jar app.jar

# Expose the default port for a Spring Boot application.
EXPOSE 8080


ENTRYPOINT ["java","-jar","/app.jar"]