### step1
> -[x] VPC 생성
>   - 90mansik-vpc로 생성 
>   - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
> -[x] Subnet 생성
>  -[x] 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
>   - 90mansik-public-a, 90mansik-public-c  
>  -[x] 내부망으로 사용할 Subnet : 32개씩 1개
>   - 90mansik-internal-a
>  -[x] 관리용으로 사용할 Subnet : 32개씩 1개
>   - 90mansik-admin-a
> -[x] Internet Gateway 연결
>   - 90mansik-igw
> - [x] Route Table 생성
> - [x]Security Group 설정
>  - [x] 외부망
>      - 전체 대역 : 8080 포트 오픈 (x)
>      - 관리망 : 22번 포트 오픈
>  - [x] 내부망
>      - 외부망 : 3306 포트 오픈 (x)
>      - 관리망 : 22번 포트 오픈
>  - [x] 관리망
>      - 자신의 공인 IP : 22번 포트 오픈
> - [x] 서버 생성
>  - [x] 외부망에 웹 서비스용도의 EC2 생성
>  - [x] 내부망에 데이터베이스용도의 EC2 생성
>  - [x] 관리망에 베스쳔 서버용도의 EC2 생성
>  - [x] 베스쳔 서버에 Session Timeout 600s 설정
>  - [x] 베스쳔 서버에 Command 감사로그 설정
> - [x] DNS 도메인 설정
>   - 90mansik.kro.kr