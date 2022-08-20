FROM nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY /home/ubuntu/nextstep/fullchain.pem /etc/letsencrypt/live/orgojy.ga/fullchain.pem
COPY /home/ubuntu/nextstep/privkey.pem /etc/letsencrypt/live/orgojy.ga/privkey.pem
