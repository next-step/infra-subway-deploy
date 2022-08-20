FROM nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY pem/fullchain.pem /etc/letsencrypt/live/orgojy.ga/fullchain.pem
COPY pem/privkey.pem /etc/letsencrypt/live/orgojy.ga/privkey.pem
