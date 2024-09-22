FROM node:latest

WORKDIR /home/ubuntu

COPY package*.json ./


RUN npm install

COPY . .


EXPOSE 8086


CMD ["npm", "start"]