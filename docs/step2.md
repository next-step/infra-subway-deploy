# 4주차 - 그럴듯한 서비스 만들기
## 2단계 - 서비스 배포하기

## 요구사항
- [x] 운영 환경 구성하기
- [x] 개발 환경 구성하기

<br>

---
## 요구사항 설명
### 운영 환경 구성하기
- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
  - [x] 외부망에 Nginx로 Reverse Proxy를 구성
  - [x] Reverse Proxy에 TLS 설정
- [x] 운영 데이터베이스 구성하기

### 개발 환경 구성하기
- [x] 설정 파일 나누기
  - JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정


<br>

---
## Dockerfile, nginx, TLS 인증서
- 디렉토리

  `/home/ubuntu/nextstep/nginx_docker`
  - Dockerfile
  - nginx.conf
  - fullchain.pem
  - privkey.pem


- Dockerfile
```dockerfile
FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf 
COPY fullchain.pem /etc/letsencrypt/live/runningmap.kro.kr/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/runningmap.kro.kr/privkey.pem
```


- nginx.conf
```
events {}

http {       
  upstream app {
    server 192.168.90.14:8080;
  }
  
  # Redirect all traffic to HTTPS
  server {
    listen 80;
    return 301 https://$host$request_uri;
  }

  server {
    listen 443 ssl;  
    ssl_certificate /etc/letsencrypt/live/runningmap.kro.kr/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/runningmap.kro.kr/privkey.pem;

    # Disable SSL
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    # 암호화 알고리즘
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

    # Enable HSTS
    add_header Strict-Transport-Security "max-age=31536000" always;

    # SSL sessions
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;      

    location / {
      proxy_pass http://app;    
    }
  }
}
```


- DNS TXT 레코드
  - TXT record `_acme-challenge`
  - Value `RX6F-pBeX02oTIapjD3au1cfxL4ALWt3mgvibdvVC6c`