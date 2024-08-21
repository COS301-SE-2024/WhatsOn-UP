FROM node:latest

WORKDIR /home/ubuntu

COPY package*.json ./


RUN npm install

COPY . .


EXPOSE 8081
EXPOSE 8082


CMD ["npm", "start"]