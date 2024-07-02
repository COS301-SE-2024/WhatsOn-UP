FROM devforce123/backend

# Set working directory
WORKDIR /home/ubuntu

# remove the existing application files
RUN rm -rf /home/ubuntu/*

# Copy the application files to the container
ADD . .

# Change permissions for Gradle wrapper
RUN chmod +x ./gradlew

# Remove Windows carriage return characters if any
RUN sed -i 's/\r//' gradlew

RUN ./gradlew build

# Expose the port
EXPOSE 8080

# Command to run the application
CMD ["./gradlew", "bootRun"]
