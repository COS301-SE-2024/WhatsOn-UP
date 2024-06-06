FROM devforce123/backend:latest

WORKDIR /home/ubuntu

COPY . .

RUN chmod +x ./gradlew

RUN ./gradlew build
RUN ./gradlew test

# Command to run the application
CMD ["./gradlew", "bootRun"]
