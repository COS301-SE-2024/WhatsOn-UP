FROM ubuntu:latest

RUN apt update && apt install -y default-jdk

WORKDIR /home/ubuntu

COPY . .

RUN chmod +x mvnw

RUN ./mvnw clean install

CMD java -jar target/Backend-0.0.1-SNAPSHOT.jar

