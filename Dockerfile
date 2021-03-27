FROM nginx:latest
RUN apt-get update
ADD . /usr/share/nginx/html
