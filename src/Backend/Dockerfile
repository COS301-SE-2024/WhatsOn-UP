FROM devforce123/backend-services:api

WORKDIR /home/ubuntu

RUN rm -rf /home/ubuntu/*

ADD . .

RUN chmod +x ./gradlew

RUN sed -i 's/\r//' gradlew

RUN ./gradlew assemble

EXPOSE 8080

CMD ["./gradlew", "bootRun"]
