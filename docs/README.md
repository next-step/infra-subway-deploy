# 그럴듯한 서비스 만들기
## 2단계 - 서비스 배포하기
### 요구사항
- [ ] 운영 환경 구성하기
- [ ] 개발 환경 구성하기

### 요구사항 설명
**운영 환경 구성하기**
- [x] 웹 애플리케이션 앞단에 Reverse Proxy 구성하기
    - [x] 외부망에 Nginx로 Reverse Proxy를 구성
        * ec2 instance name : enemfk777-ec2-public-reverse-proxy
        * bastion alias name : nginx ex) ssh ubuntu@nginx
        * enemfk777-security-group-nginx security group 적용
            * 인바운드 80포트 모든 IP에 오픈
            * 인바운드 443포트 모든 IP에 오픈
            * 인바운드 22포트 admin subnet 대역에 대해 오픈
        * RUNNINGMAP 어플리케이션이 구동되는 인스턴스의 enemfk777-security-group-public security gorup은 인바운드 범위 축소
            * 인바운드 8080포트 public subnet 01 (reverse proxy 인스턴스가 속한 subnet)의 대역
            * 인바운드 22포트 admin subnet 대역에 대해 오픈
    - [x] Reverse Proxy에 TLS 설정
      * https://public.enemfk777.kro.kr/
- [ ] 운영 데이터베이스 구성하기
