FROM node:18-bullseye-slim

RUN apt-get update --fix-missing && apt-get install -y python build-essential && apt-get clean

WORKDIR /lhci

COPY package*.json ./

COPY server.js .

RUN npm install

EXPOSE 9001

CMD [ "npm", "start" ]
