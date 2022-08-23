FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY fullchain.pem /etc/letsencrypt/live/xn--26-7z8jv1z.xn--h32bi4v.xn--3e0b707e/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/xn--26-7z8jv1z.xn--h32bi4v.xn--3e0b707e/privkey.pem
