FROM nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/fullchain.pem /etc/letsencrypt/live/writer0713.o-r.kr/fullchain.pem
COPY conf/privkey.pem /etc/letsencrypt/live/writer0713.o-r.kr/privkey.pem