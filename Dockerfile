FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY fullchain.pem /etc/letsencrypt/live/realizeme.o-r.kr/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/realizeme.o-r.kr/privkey.pem
