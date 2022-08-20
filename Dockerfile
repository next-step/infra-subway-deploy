FROM nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ~/nextstep/fullchain.pem /etc/letsencrypt/live/orgojy.ga/fullchain.pem
COPY ~/nextstep/privkey.pem /etc/letsencrypt/live/orgojy.ga/privkey.pem
