FROM devforce123/backend:latest

RUN rm -rf /home/ubuntu/*

WORKDIR /home/ubuntu

COPY . .

RUN chmod +x ./gradlew

RUN sed -i 's/\r//' gradlew

RUN ./gradlew build

EXPOSE 8080
CMD ["./gradlew", "bootRun"]

