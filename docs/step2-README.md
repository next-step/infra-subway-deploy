# Step2. 서비스 배포하기

# 목표

### 운영 환경 구성하기

- 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
  - 외부망에 Nginx로 Reverse Proxy를 구성
  - Reverse Proxy에 TLS 설정
- 운영 데이터베이스 구성하기

### 개발 환경 구성하기

- profile 별 설정 파일 분리
  - test : h2
  - local : docker(mysql)
  - prod : 운영 DB

# TODO List

### Reverse Proxy 구성

- Reverse Proxy 세팅
  - [ ] Docker 설치
  - [ ] nginx Dockerfile 작성
  - [ ] nginx.conf 설정
  - [ ] docker build & run

- Reverse Proxy 설정
  - [ ] TLS 설정
    - [ ] letsencrypt를 이용한 인증서 생성
    - [ ] 유효한 URL인지 확인을 위한 `DNS TXT 레코드`로 추가
      - TXT 레코드 설정
      - DNS TXT 레코드를 적용 여부 확인 : $ dig -t txt _acme-challenge.example.com +short
    - [ ] Dockerfile에 인증서 설정 추가
    - [ ] nginx.conf에 SSL 설정 추가
    - [ ] ssl 적용 여부 확인

### Database 설정

- [ ] Docker 설치
- [ ] docker build & run
- [ ] docker를 이용한 mysql 구동 확인
  ```shell
  $docker exec -it {docker container name or id} mysql -u root -p
  ```
  ```mysql
  show databases;
  use subway;
  show tables;
  ```

### 설정 파일 분리

- [ ] application-{profiles} 분리
- [ ] 변경사항 적용
  - [ ] git clone -b step2 --single-branch https://github.com/hahoho87/infra-subway-deploy.git
  - [ ] nohup java -jar -Dspring.profiles.active=prod subway-0.0.1-SNAPSHOT.jar 1> infra-subway-deploy-log 2>&1 &

### Database 테이블 스키마 버전 관리

- [ ] flyway 설정

### 설정 별도 관리

- [ ] github private repository 생성
  - hahoho87/infra-subway-deploy-config
  - [ ] 리뷰어 권한 부여
- [ ] `submodule` 기능 활용 `private repository` 참조 설정

---

### 작업 내용


