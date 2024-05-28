FROM ubuntu:latest

RUN apt update && apt install -y default-jdk maven

WORKDIR /home/ubuntu

COPY . .

RUN mvn clean install

CMD java -jar target/Backend-0.0.1-SNAPSHOT.jar

