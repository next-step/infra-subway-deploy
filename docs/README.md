## STEP2

### 2단계 - 서비스 배포하기

### 요구사항

#### 운영 환경 구성하기

- [ ] 웹 어플리케이션 앞단에 Reverse Proxy 구성하기
    - [ ] 외부망에서 Nginx 로 Reverse Proxy 를 구성
    - [ ] Reverse Proxy 에 TLS 설정
- [ ] 운영 데이터베이스 구성하기

#### 개발 환경 구성하기
- 운영 환경 구성 하기 시작 
  - 외부망에서 Nginx 로 Reverse Proxy 를 구성
    - docker 를 먼저 외부망에 있는 Ec2 에 설치 ([mannue] External-EC2)
    - Reverse Proxy 가 모든 traffic 을 받을수 있도록 Security Group 에서 0.0.0.0 에 80 포트 으로 변경 (현재 web 서버는 8080으로 받음)
      ```text
        $ sudo apt-get update && \
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
        sudo apt-key fingerprint 0EBFCD88 && \
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
        sudo apt-get update && \
        sudo apt-get install -y docker-ce && \
        sudo usermod -aG docker ubuntu && \
        sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
        sudo chmod +x /usr/local/bin/docker-compose && \
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
      ```
      - 위 명령어를 사용하여 docker 설치
      ```text
         FROM nginx
                  
         COPY nginx.conf /etc/nginx/nginx.conf
      ```
      - 위 내용으로 Dockerfile 생성  
      ```text
         events {}

          http {
              upstream app {
                     server 172.17.0.1:8080;
              }
    
               server {
                   listen 80;
    
                   location / {
                       proxy_pass http://10.252.100.113:8080;
                   }
               }
          }
      ```
      - 위 내용으로 nginx 설정 파일 구성 
      - docker 빌드 와 실행 
      ```text
         docker build -t nextstep/reverse-proxy .
         docker run -d -p 80:80 nextstep/reverse-proxy
      ```
  - TLS 설정
    - [도메인신청](https://xn--220b31d95hq8o.xn--3e0b707e/) << 여기 사이트에서 도메인을 먼저 신청!!!
    - 아래 명령어를 사용해서 인증서 발급
    ```text
       docker run -it --rm --name certbot \
       -v '/etc/letsencrypt:/etc/letsencrypt' \
       -v '/var/lib/letsencrypt:/var/lib/letsencrypt' \
       certbot/certbot certonly -d 'yourdomain.com' --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory
    ```
    - 인증서 복사 와 Docker 파일 수정 
    ```text
      // 인증서 생성 
      cp /etc/letsencrypt/live/mannue.kro.kr/fullchain.pem ./
      cp /etc/letsencrypt/live/mannue.kro.kr/privkey.pem ./
                
      // Dockerfile 수정
      FROM nginx

      COPY nginx.conf /etc/nginx/nginx.conf
      COPY fullchain.pem /etc/letsencrypt/live/mannue.kro.kr/fullchain.pem
      COPY privkey.pem /etc/letsencrypt/live/mannue.kro.kr/privkey.pem
    ```
    - nginx config 파일 수정
    ```text
          events {}

          http {       
          upstream app {
          server 172.17.0.1:8080;
          }
                    
          # Redirect all traffic to HTTPS
          server {
          listen 80;
          return 301 https://$host$request_uri;
          }
                    
          server {
          listen 443 ssl;  
          ssl_certificate /etc/letsencrypt/live/[도메인주소]/fullchain.pem;
          ssl_certificate_key /etc/letsencrypt/live/[도메인주소]/privkey.pem;
                    
              # Disable SSL
              ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
                    
              # 통신과정에서 사용할 암호화 알고리즘
              ssl_prefer_server_ciphers on;
              ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;
                    
              # Enable HSTS
              # client의 browser에게 http로 어떠한 것도 load 하지 말라고 규제합니다.
              # 이를 통해 http에서 https로 redirect 되는 request를 minimize 할 수 있습니다.
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
    - 기존 docker 중지 와 삭제 후 빌드해서 다시 start
    ```text
       $ docker stop proxy && docker rm proxy
       $ docker build -t nextstep/reverse-proxy:0.0.2 .
       $ docker run -d -p 80:80 -p 443:443 --name proxy nextstep/reverse-proxy:0.0.2

    ```
    - nginx config 파일에서 80 포트로 traffic 이 올경우 301 redirect 다시 요청을 요구 함으로 security group에 443을 오픈해야 한다. 
  
  - 컨테이너로 운영 DB 사용하기
      - internal EC2에 docker 설치 (외부망 나가는 연결이 안되었을 경우 NAT 를 설치하여 router table 에 추가)
      - docker search 를 통해서 아래 도커 이미지를 검색
      ```text
         docker run -d -p 3306:3306 brainbackdoor/data-subway:0.0.1
      ```
- 개발 환경 구성하기
  - application-test.properties, application-local.properties, application-prd.properties 파일 생성
  ```text
      spring.profiles.active=test
  ```
  - build 시 default 로 H2로 테스트 되도록 변경 
  - build 성공 후 아래 명령어로 web 서버 시작
  ```text
      java -jar -Dspring.profiles.active=prd /build/libs/XXXX.jar 
  ```
- STEP2 마무리 하고 문제점
  - external ec2 의 public ip가 변경됨으로써 내도메인 한국 에서 ip 를 수정해야 함

---------------
---------------
## STEP 3

### 3단계 - 배포 스크립트 작성하기

#### 요구사항
- [ ] 배포 스크립트 작성하기

#### 메모
- /etc/crontab 과 crontab 차이
  - 권한의 차이로 /etc/crontab 을 사용시 권한이 있어야 하며 없을 경우 crontab -e 를 사용하여 등록하면 된다.

              