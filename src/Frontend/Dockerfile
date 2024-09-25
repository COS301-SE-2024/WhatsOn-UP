# Use Nginx to serve the Flutter web app
FROM nginx:alpine

# Copy the Flutter web build output to Nginx's HTML directory
COPY . /usr/share/nginx/html

# Expose port 80 to serve the web app
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
