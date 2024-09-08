FROM node:latest

WORKDIR /home/ubuntu

COPY package*.json ./


RUN npm install

COPY . .


EXPOSE 8083


CMD ["npm", "start"]