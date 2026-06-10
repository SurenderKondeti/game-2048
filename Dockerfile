FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy game files from repo directly into nginx web root
COPY . /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
