FROM devforce123/backend-services:deployment-image

WORKDIR /home/ubuntu

RUN rm -rf /home/ubuntu/*

COPY . /home/ubuntu

WORKDIR /home/ubuntu/scripts

RUN chmod +x *.sh

RUN sudo systemctl start docker

RUN gcloud projects set project whatsonup

RUN ./deploy.sh

RUN sudo systemctl stop docker


