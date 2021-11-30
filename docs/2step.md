# 🚀 2단계 - 서비스 배포하기

# 요구사항

<img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/f35d730a4d604ff18c127a907232f016>

- 운영 환경 구성하기
- 개발 환경 구성하기

# 요구사항 설명

## 운영 환경 구성하기

- [ ] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [ ] 외부망에 Nginx로 Reverse Proxy를 구성
    - [ ] Reverse Proxy에 TLS 설정
- [ ] 운영 데이터베이스 구성하기

## 개발 환경 구성하기

- [ ] 설정 파일 나누기
    - [ ] JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
- [ ] 데이터베이스 테이블 스키마 버전 관리

# 힌트

### 도커 설치

```
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

- [도커 플레이그라운드](https://github.com/brainbackdoor/playground-docker/tree/master/week1)

## 1. Reverse Proxy

[https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/e964428368184715b3f3c7d4192e7438](https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/e964428368184715b3f3c7d4192e7438)

우리의 WAS는 비즈니스 로직만 담당하도록 구성하고 싶어요. TLS와 같은 부수적인 기능으로 애플리케이션에 직접 영향을 주고 싶지 않아요. 그럴 때 중간에 대신 역할을 수행하는 녀석이 필요한데, 여기서는
Reverse Proxy가 그 녀석입니다.

**Reverse Proxy**는 클라이언트로부터의 요청을 받아서(필요하다면 주위에서 처리한 후) 적절한 웹 서버로 요청을 전송합니다. 웹 서버는 요청을 받아서 평소처럼 처리를 하지만, 응답을 클라이언트로 보내지
않고 Reverse Proxy로 반환합니다. 요청을 받은 Reverse Proxy는 그 응답을 클라이언트로 반환합니다.

통상의 Proxy Server는 LAN -> WAN의 요청을 대리로 수행합니다. 가령, 특정 웹 서비스에 접속하고 싶은데 해당 서비스에서 한국 IP 대역을 막아두었다면, 다른 국가를 통해 접속할 때 Proxy를
활용합니다. 반면 Reverse Proxy는 WAN -> LAN의 요청을 대리합니다. 즉, 클라이언트로부터의 요청이 웹서버로 전달되는 도중의 처리에 끼어들어서 다양한 전후처리를 시행할 수가 있게 됩니다.

[https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/fb7860525f2a4ad286781ff87d06d118](https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/fb7860525f2a4ad286781ff87d06d118)

### Reverse Proxy와 Load Balancer는 어떤 차이가 있을까요?

- [Reverse Proxy](https://brainbackdoor.tistory.com/113) : 보안성 향상, 확장성 향상, 웹 가속(압축/SSL 처리로 백엔드 리소스 확보/캐싱)
- Load Balancer : 부하분산, 서버상태 체크, 세션 관리

역할이라고 생각하면 좋겠어요. 가령, nginx는 Reverse Proxy, Load Balancer 두가지 역할을 수행할 수 있는건지요.

### a. Dockerfile

```
FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf

```

### b. nginx.conf

```
events {}

http {
  upstream app {
    server 172.17.0.1:8080;
  }

  server {
    listen 80;

    location / {
      proxy_pass http://app;
    }
  }
}

```

```
$ docker build -t nextstep/reverse-proxy .
$ docker run -d -p 80:80 nextstep/reverse-proxy

```

## 2. TLS 설정

서버의 보안과 별개로 서버와 클라이언트간 통신상의 암호화가 필요합니다. 평문으로 통신할 경우, 패킷을 스니핑할 수 있기 때문입니다.

📌 letsencrypt를 활용하여 무료로 TLS 인증서를 사용할 수 있어요.

```
$ docker run -it --rm --name certbot \
  -v '/etc/letsencrypt:/etc/letsencrypt' \
  -v '/var/lib/letsencrypt:/var/lib/letsencrypt' \
  certbot/certbot certonly -d 'yourdomain.com' --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory

```

📌 인증서 생성 후 유효한 URL인지 확인을 위해 DNS TXT 레코드로 추가합니다.

[https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/ad712ce0a1b943b18cef2cb255c2baf5](https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/ad712ce0a1b943b18cef2cb255c2baf5)

📌 생성한 인증서를 활용하여 Reverse Proxy에 TLS 설정을 해봅시다. 우선 인증서를 현재 경로로 옮깁니다.

```
$ cp /etc/letsencrypt/live/[도메인주소]/fullchain.pem ./
$ cp /etc/letsencrypt/live/[도메인주소]/privkey.pem ./

```

📌 Dockerfile 을 아래와 같이 수정합니다.

```
FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY fullchain.pem /etc/letsencrypt/live/[도메인주소]/fullchain.pem
COPY privkey.pem /etc/letsencrypt/live/[도메인주소]/privkey.pem

```

📌 nginx.conf 파일을 아래와 같이 수정합니다.

```
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

📌 방금전에 띄웠던 도커 컨테이너를 중지 & 삭제하고 새로운 설정을 반영하여 다시 띄워봅시다.

```
$ docker stop proxy && docker rm proxy
$ docker build -t nextstep/reverse-proxy:0.0.2 .
$ docker run -d -p 80:80 -p 443:443 --name proxy nextstep/reverse-proxy:0.0.2

```

## 3. 컨테이너로 운영 DB 사용하기

일반적으로, 실제 운영환경에서 컨테이너로 데이터베이스의 영속성 데이터를 다루지 않습니다. 컨테이너의 철학과 데이터베이스의 영속성은 다소 배치되는 부분이 있다고 생각합니다. 여기서는 원활한 실습을 위해 제가 미리
push해둔 컨테이너를 활용합니다.

- id : root / password: masterpw

```
$ docker run -d -p 3306:3306 brainbackdoor/data-subway:0.0.1

```

## 4. 설정 파일 나누기

<img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/02ff304a9386431fb66e3b3c47cda04f>

- 실제로 배포를 하려다보면, JUnit을 활용한 test 단계와 local 환경에서 직접 애플리케이션을 확인할 때, 그리고 실제로 배포할 때 등 **각 상황에 맞춰 설정을 다르게 적용할 필요성**이 생깁니다.
- [예제 코드](https://github.com/woowacourse/java-deploy/tree/feat/properties)를 통해 test와 local, prod에서 다른 설정을 사용하는 방법을
  익혀봅시다.
- **Dspring.profiles.active=prod** 옵션을 추가하여 실행하면 **`application-prod.properties`**의 설정을 사용합니다.

```
$ java -jar -Dspring.profiles.active=prod [jar파일명]

```

## 5. 데이터베이스 테이블 스키마 버전관리

- 운영중인 서비스의 경우 JPA 등 ORM을 사용하여 기존의 테이블을 변경하는 것은 데이터 유실 우려, 참조 무결성 제약 등으로 인해 어려움이 있습니다. 그리고 데이터베이스 테이블 스키마도 버전관리를 할 필요가
  있습니다. 그럴 때 로컬에서 개발 중일 때는 h2 등 in-memory 형태의 데이터베이스를 사용하여 빠르게 개발하고, 운영 DB는 점진적으로 migration 해가는 전략이 유용합니다.
- [예제 코드](https://github.com/woowacourse/java-deploy/tree/feat/flyway)를 통해 데이터베이스 스키마 관리 전략을 확인해봅니다.
    - 예제코드를 실행하기에 앞서, [도커](https://www.docker.com/products/docker-desktop)를 다운로드하세요.
    - **docker/db/mysql/init**에 dump 파일을 넣은 상태로 실행하면 자동으로 초기 데이터를 INSERT할 수 있어요.
    - flyway는 **V__[변경이력].sql**의 형태로 **resources/db/migration/** 경로에서 관리합니다. 그리고 flyway_schema_history 테이블에 버전별로
      checksum 값을 관리하므로 기존 sql 문을 수정해서는 안됩니다.

```
# 터미널에서 docker-compose.yml이 있는 위치로 이동한다.
$ cd docker
$ docker-compose up -d

```

### 기존 Database 존재시 flyway 적용 방법

```
# application.properties
spring.flyway.baseline-on-migrate=true
spring.flyway.baseline-version=2

```

이전에 database가 존재할 경우 baseline 옵션을 활용하면 특정 버전(V2__xx.sql 파일) 내용부터 적용이 가능해요.

## [추가] 설정 별도로 관리하기

- **키, 계정 정보, 접속 URL 등의 설정 정보**를 소스코드와 함께 형상관리할 경우 보안 이슈가 발생할 수 있어 따로 관리할 것이 권장됩니다. 보통 Jenkins / Travis CI 등의 배포 서버에
  파라미터를 지정하거나, Spring Cloud Config / AWS Service Manager 등의 외부 서비스를 활용하는 방안 등이 활용됩니다. 여기서는 저장소를 분리하여 private
  repository에서 설정을 관리하도록 합니다.

### a. 우선, github private 저장소를 생성한 후 application.properties 등의 설정 파일을 올립니다.

### b. git의 [서브모듈 기능](https://git-scm.com/book/ko/v2/Git-%EB%8F%84%EA%B5%AC-%EC%84%9C%EB%B8%8C%EB%AA%A8%EB%93%88)을 활용하여 특정 경로에 private repository를 참조하도록 설정합니다

```
$ git submodule add [자신의 private 저장소] ./src/main/resources/config

```

- 이후에 소스코드를 받을 떄는 서브모듈까지 clone해야 합니다.

```
$ git clone --recurse-submodules [자신의 프로젝트 저장소]

```

### c. 설정 파일의 내용이 변경된 경우

```
git submodule foreach git pull origin main

git submodule foreach git add .

git submodule foreach git commit -m "commit message"

git submodule foreach git push origin main

```

## [추가] 정적테스트(SonarLint)

- Sonarqube / ESLint 등 **정적 테스트**, Maven / Gradle 등을 활용한 **Build**, JUnit 등을 활용한 **동적 테스트** 등을 통해 Code로 인해 발생하는 문제를 조기에
  발견할 수 있습니다. 어떻게 하면 테스트 비용을 줄일 수 있을지 늘 고민해봅니다.
- [SonarLint](http://redutan.github.io/2018/04/11/intellij-sonarlint-plugin) 를 활용하면 정적테스트 구축비용을 줄일 수 있습니다.
    - 정적 테스트를 통해 Coding Convention, 중복코드, 소스코드의 복잡도, 잠재적으로 버그 발생 가능성이 있는 코드, 테스트 커버리지 등을 파악할 수 있습니다.

## [추가] 로컬테스트(MultiRun)

- 로컬에서 서버를 띄울 때, IntelliJ의 [Multirun](https://plugins.jetbrains.com/plugin/7248-multirun) 플러그인을 활용하면 보다 손 쉽게 서버를 띄울 수
  있습니다.
    - Multi Run 플러그인 설치

      <img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/d4a88de08f49446a9d3993bc934ee24a>

    - Multi Run 설정
        - IntelliJ -> Run -> Edit Configurations...
        - Docker 설정

          <img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/018d1274a23a4e75b87da1ed33e67b73>

        - NPM 설정

          <img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/9de33c2550664ec8840a25b8d56d4d28>

        - Multi Run 설정

          <img src=https://techcourse-storage.s3.ap-northeast-2.amazonaws.com/1b9970efeb584ddca4fc75f2456eb275>