# ==================================
# Stage 1: Build the application
# ==================================
FROM openjdk:24-jdk-slim AS builder

WORKDIR /app

# Copy the Maven wrapper and pom.xml first to leverage Docker layer caching
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# =============================
# === ADD THIS LINE TO FIX ===
# =============================
# Grant execute permission to the mvnw script
RUN chmod +x ./mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Build the application, skipping tests for a faster build.
RUN ./mvnw package -DskipTests

# ==================================
# Stage 2: Create the final image
# ==================================
FROM eclipse-temurin:24-jre-alpine

WORKDIR /app

# Copy ONLY the built .jar file from the 'builder' stage into the final image.
COPY --from=builder /app/target/moderndevbackend-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]