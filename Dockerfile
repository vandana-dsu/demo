# Use an official Nginx runtime as a base image
FROM nginx:alpine

# Set the working directory to /app
WORKDIR /app

# Copy the contents of the src directory to the container at /app
COPY src/ /app

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the application
CMD ["nginx", "-g", "daemon off;"]
