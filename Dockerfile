FROM nginx:1.21.3


RUN apt update \
    && apt install -y curl git \
    && apt -y autoclean

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash

RUN apt install -y \
    nodejs libc-client-dev libkrb5-dev


RUN apt clean && rm -rf /var/lib/apt/lists/*


COPY ./nginx/app.conf /etc/nginx/conf.d/client.conf

ARG uid=1000
                 
WORKDIR /app

RUN npm install -g npm@8.2.0

#RUN npm run build 

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
