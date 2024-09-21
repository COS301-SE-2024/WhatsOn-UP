FROM devforce123/backend-services:deployment-image

WORKDIR /home/ubuntu

# Remove all files in the directory
RUN rm -rf /home/ubuntu/*

# Copy the local files to the container
COPY . /home/ubuntu

WORKDIR /home/ubuntu/scripts

# Make all .sh scripts executable
RUN chmod +x *.sh

# Set the active Google Cloud project
RUN gcloud config set project whatsonup

# Run the deploy script
RUN ./deploy.sh
