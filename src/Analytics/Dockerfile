FROM devforce123/backend-service:analytics


WORKDIR /home/ubuntu

RUN rm -rf /home/ubuntu/*

ADD . .

RUN chmod +x ./gradlew

RUN sed -i 's/\r//' gradlew

RUN ./gradlew assemble

EXPOSE 8084

CMD ["./gradlew", "bootRun"]
