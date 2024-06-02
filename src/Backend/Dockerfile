FROM devforce123/backend:latest

WORKDIR /home/ubuntu

COPY . .

RUN ./gradlew build

# Command to run the application
CMD ["./gradlew", "bootRun"]
