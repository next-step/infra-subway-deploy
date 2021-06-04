# 그럴듯한 서비스 만들기
## 2단계 - 서비스 배포하기
### 요구사항
- [ ] 운영 환경 구성하기
- [ ] 개발 환경 구성하기

### 요구사항 설명
**운영 환경 구성하기**
- [ ] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [x] 외부망에 Nginx로 Reverse Proxy를 구성
    - [x] Reverse Proxy에 TLS 설정
- [ ] 운영 데이터베이스 구성하기

**개발 환경 구성하기**
- [ ] 설정 파일 나누기
    * JUnit : h2, Local : docker(mysql), Prod : 운영 DB를 사용하도록 설정
- [ ] 데이터베이스 테이블 스키마 버전 관리
- [ ] SonarLint 설정하기
- [ ] MultiRun 설정하기
