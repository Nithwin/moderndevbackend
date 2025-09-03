# Stage 1: Build the application with JDK 24
# Use a Maven image with OpenJDK 24 to build the project.
FROM maven:3.9.5-openjdk-24 AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy the entire project into the container.
COPY . .

# Build the project, skipping tests to make the build faster.
RUN mvn clean package -DskipTests

# Stage 2: Create the final production-ready image
# Use a smaller JRE-only image for the final application, based on JDK 24.
FROM openjdk:24-jre-slim

# Set the volume for temporary files.
VOLUME /tmp

# Copy the built JAR file from the 'build' stage into this new, smaller image.
COPY --from=build /app/target/*.jar app.jar

# Expose the default port for a Spring Boot application.
EXPOSE 8080

# Define the command to run the application when the container starts.
ENTRYPOINT ["java","-jar","/app.jar"]