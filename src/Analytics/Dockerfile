# Use a stable JDK image
FROM openjdk:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy project files into container
COPY . .

# Give execution permissions to the Gradle wrapper
RUN chmod +x ./gradlew

# Fix line endings if necessary
RUN sed -i 's/\r//' ./gradlew

# Build the project using Gradle
RUN ./gradlew assemble

# Expose the application port
EXPOSE 8084

# Command to start the Spring Boot application
CMD ["./gradlew", "bootRun"]
