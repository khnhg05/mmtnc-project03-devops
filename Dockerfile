# Use Nginx as the base image
FROM nginx:alpine

# Copy the static website files to the Nginx html directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
