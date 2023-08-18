# Use an official Ubuntu 20.04 Docker image.
FROM ubuntu:20.04

# Update and install essential packages
RUN apt-get update && apt-get install -y curl

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# Set the working directory
WORKDIR /home/site/wwwroot

# Copy package.json and package-lock.json
COPY package*.json ./

# Copy server.js
COPY server.js .

# Install dependencies
RUN npm install

# Expose port 9001
EXPOSE 9001

# Run the Lighthouse CI server
CMD [ "npm", "start" ]
