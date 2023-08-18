# Use an official Ubuntu 20.04 Docker image.
FROM ubuntu:20.04

# Set variable so puppeteer will not try to download chromium
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
ENV CHROME_PATH=/usr/bin/google-chrome-stable

# Update and install essential packages
RUN apt-get update && apt-get install -y curl wget

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# Add Google Chrome's public key
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Add Google Chrome to the sources list
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /lhci

COPY . .

RUN npm install

CMD [ "npm", "start" ]