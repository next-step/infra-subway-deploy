FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY fullchain.pem /etc/letsencrypt/live/sangholee-dev.p-e.kr/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/sangholee-dev.p-e.kr/privkey.pem
