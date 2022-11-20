FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY src/main/resources/config/fullchain.pem /etc/letsencrypt/live/jimbae.com/fullchain.pem
COPY src/main/resources/config/privkey.pem /etc/letsencrypt/live/jimbae.com/privkey.pem
