FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf 
COPY fullchain.pem /etc/letsencrypt/live/kodo92.kro.kr/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/kodo92.kro.kr/privkey.pem