FROM nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ../fullchain.pem /etc/letsencrypt/live/orgojy.ga/fullchain.pem
COPY ../privkey.pem /etc/letsencrypt/live/orgojy.ga/privkey.pem
