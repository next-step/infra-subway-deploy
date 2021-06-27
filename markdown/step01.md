# 1단계 - 망 구성하기

## 1. 요구사항 정의

### 1.1. 명시된 요구사항

#### 1.1.1. 요구사항

- 웹 서비스를 운영할 네트워크 망 구성하기
- 웹 애플리케이션 배포하기

##### 1.1.1.1. 요구사항 설명

- VPC 생성
    - CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
- Subnet 생성
    - 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
    - 내부망으로 사용할 Subnet : 32개씩 1개
    - 관리용으로 사용할 Subnet : 32개씩 1개
- Internet Gateway 연결
- Route Table 생성
- Security Group 설정
    - 외부망
        - 전체 대역 : 8080 포트 오픈
        - 관리망 : 22번 포트 오픈
    - 내부망
        - 외부망 : 3306 포트 오픈
        - 관리망 : 22번 포트 오픈
    - 관리망
        - 자신의 공인 IP : 22번 포트 오픈
- 서버 생성
    - 외부망에 웹 서비스용도의 EC2 생성
    - 내부망에 데이터베이스용도의 EC2 생성
    - 관리망에 베스쳔 서버용도의 EC2 생성
    - 베스쳔 서버에 Session Timeout 600s 설정
    - 베스쳔 서버에 Command 감사로그 설정

> 주의사항
> - 다른 사람이 생성한 리소스는 손대지 말아요 🙏🏻
> - 모든 리소스는 태그를 작성합니다. 이 때 자신의 계정을 Prefix로 붙입니다. (예: brainbackdoor-public)

##### 1.1.1.2. 웹 애플리케이션 배포

- 외부망에 웹 애플리케이션을 배포
- DNS 설정

#### 1.1.2. 힌트

##### 1.1.2.1. EC2 생성하기

1. [aws web console](https://console.aws.amazon.com/console/home) 에 사용자 이름 / 비밀번호 등을 입력하여 접속합니다.
2. EC2 메뉴로 접근하세요.
    1. Ubuntu 64 bit 선택 (Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-00edfb46b107f643c)
    2. InstanceType : t2.micro 혹은 t2.medium 생성 가능
    3. 서브넷 : 적절한 서브넷 선택, 퍼블릭 IP 자동할당 : 활성화
    4. 스토리지 : 서비스 운영할 것을 고려해서 설정해주세요.
    5. 서버를 생성할 때는 다른 사람의 서버와 구분하기 위해 반드시 Name 이름으로 태그에 자신의 계정명을 작성합니다.
    6. 보안그룹 : 적절한 보안그룹을 선택
    7. 키 페어 생성
        - 키 페어 이름에 자신의 계정을 prefix로 붙입니다.
        > - 서버 생성시 발급받은 key를 분실할 경우 서버에 접속할 수 없어요. key를 분실하지 않도록 주의하세요,
        > - key는 최초 1회 생성한 후 재사용합니다.

        > 서버를 사용하지 않을 때는 stop해주세요.
       
3. 서버에 접속하기
   
    > 서버 IP는 aws web console에서 확인 가능
    
    1. 맥 운영체제 사용자
        ```shell
        # 터미널 접속한 후 앞 단계에서 생성한 key가 위치한 곳으로 이동한다.
        $ chmod 400 [pem파일명]
        $ ssh -i [pem파일명] ubuntu@[SERVER_IP]
        ```
    2. 윈도우즈 운영체제 사용자
        - [PuTTY를 사용하여 Windows에서 Linux 인스턴스에 연결](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/putty.html)
        - [putty를 위한 ppk 생성](https://klero.tistory.com/entry/AWS-EC2-%EC%82%AC%EC%9A%A9-pem%ED%82%A4-ppk%EB%A1%9C-%EB%B3%80%ED%99%98%ED%95%98%EC%97%AC-Putty-SSH-%EC%A0%91%EC%86%8D%EB%B0%A9%EB%B2%95)

##### 1.1.2.2. 접근통제

1. 개요
    - Bastion 이란, 성 외곽을 보호하기 위해 돌출된 부분으로 적으로부터 효과적으로 방어하기 위한 수단입니다. 이를 우리의 아키텍쳐에도 적용해볼 수 있습니다.
    - 가령, 우리가 터미널에 접속하기 위해 사용하는 22번 포트를 한번 생각해보아요. 22번 포트의 경우 보안이 뚫린다면 서비스에 심각한 문제를 일으킬 수 있습니다. 그렇다고, 모든 서버에 동일 수준의 보안을 설정하고자 한다면, Auto-Scaling 등 확장성을 고려한 구성과 배치됩니다. 이 경우 관리 포인트가 늘어나기에 일반적으로는 보안 설정을 일정 부분을 포기하는 결정을 하게 됩니다. 만약 Bastion Server가 있다면, 악성 루트킷, 랜섬웨어 등으로 피해를 보더라도 Bastion Server만 재구성하면 되므로, 서비스에 영향을 최소화할 수 있습니다.
    - 추가적으로, 서비스 정상 트래픽과 관리자용 트래픽을 구분할 수 있다는 이점이 있습니다. 가령, 서비스가 DDos 공격을 받아 대역폭을 모두 차지하고 있다면 일반적인 방법으로 서비스용 서버에 접속하기는 어렵기 때문에 별도의 경로를 확보해둘 필요가 있습니다.
    - 따라서, 22번 Port 접속을 Bastion 서버에 오픈하고 그 서버에 보안을 집중하는 것이 효율적입니다.
2. Bastion Server로 사용할 별도의 EC2를 생성하고, Bastion Server에서 서비스용 서버에 ssh 연결을 설정해봅시다.
    ```shell
    ## Bastion Server에서 공개키를 생성합니다.
    bastion $ ssh-keygen -t rsa
    bastion $ cat ~/.ssh/id_rsa.pub
    
    ## 접속하려는 서비스용 서버에 키를 추가합니다.
    $ vi ~/.ssh/authorized_keys
    
    ## Bastion Server에서 접속을 해봅니다.
    bastion $ ssh ubuntu@[서비스용 서버 IP]
    ```
3. Bastion Server는 자신의 공인 IP에서만 22번 포트로 접근이 가능하도록 Security Group을 설정합니다.
4. 서비스용 서버에 22번 포트로의 접근은 Bastion 서버에서만 가능하도록 Security Group을 설정합니다.
5. Bastion 서버에서 다른 서버에 접근이 용이하도록 별칭을 설정합니다.
    ```shell
    bastion $ vi /etc/hosts
    [서비스용IP]    [별칭]
    
    bastion $ ssh [별칭]
    ```

##### 1.1.2.3. 서버 설정 해보기

1. 환경변수 적용하기
    - Sessio Timeout 설정을 하여 일정 시간 작업을 하지 않을 경우 터미널 연결을 해제할 수 있습니다.

    ```shell
    $ sudo vi ~/.profile
    HISTTIMEFORMAT="%F %T -- "    ## history 명령 결과에 시간값 추가
    export HISTTIMEFORMAT
    export TMOUT=600              ## 세션 타임아웃 설정
    
    $ source ~/.profile
    $ env
    ```

2. shell prompt 변경하기
    - Bastion 등 구분해야 하는 서버의 Shell Prompt를 설정하여 관리자의 인적 장애를 예방할 수 있습니다.
        - [쉘변수](https://webdir.tistory.com/105)
        - [PS1 generator](https://ezprompt.net/)

    ```shell
    $ sudo vi ~/.bashrc
    USER=BASTION
    PS1='[\e[1;31m$USER\e[0m][\e[1;32m\t\e[0m][\e[1;33m\u\e[0m@\e[1;36m\h\e[0m \w] \n\$ \[\033[00m\]'
    
    $ source ~/.bashrc
    ```
   
3. [logger](https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_logger) 를 사용하여 감사로그 남기기
    - 서버에 직접 접속하여 작업할 경우, 작업 이력 히스토리를 기록해두어야 장애 발생시 원인을 분석할 수 있습니다. 감사로그를 기록하고 수집해봅니다.

    ```shell
    $ sudo vi ~/.bashrc
    tty=`tty | awk -F"/dev/" '{print $2}'`
    IP=`w | grep "$tty" | awk '{print $3}'`
    export PROMPT_COMMAND='logger -p local0.debug "[USER]$(whoami) [IP]$IP [PID]$$ [PWD]`pwd` [COMMAND] $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'
    
    $ source  ~/.bashrc
    ```

    ```shell
    $ sudo vi /etc/rsyslog.d/50-default.conf
    local0.*                        /var/log/command.log
    
    $ sudo service rsyslog restart
    $ tail -f /var/log/command.log
    ```

##### 1.1.2.4. 소스코드 배포, 빌드 및 실행

1. 자바 설치

    ```shell
    $ sudo apt update
    $ sudo apt install default-jre
    $ sudo apt install default-jdk
    ```

2. github repository clone

3. 빌드

    ```shell
    $ ./gradlew clean build

    # jar파일을 찾아본다.
    $ find ./* -name "*jar"
    ```

4. 실행
    - Application을 실행 후 정상적으로 동작하는지 확인해보세요.
        ```shell
        $ java -jar [jar파일명] & 

        $ curl http://localhost:8080
        ```
    - -Dserver.port=8000 옵션을 활용하여 port를 변경할 수 있어요.
    - 서버를 시작 시간이 너무 오래 걸리는 경우 -Djava.security.egd 옵션을 적용해보세요.
        - 이 옵션을 붙이는 이유가 궁금하다면 [tomcat 구동 시 /dev/random 블로킹 이슈](https://lng1982.tistory.com/261) 참고.
            ```shell
            $ java -Djava.security.egd=file:/dev/./urandom -jar [jar파일명] &
            ```
    - 터미널 세션이 끊어질 경우, background로 돌던 프로세스에 hang-up signal이 발생해 죽는 경우가 있는데요. 이 경우 nohup명령어를 활용합니다.
        ```shell
        $  nohup java -jar [jar파일명] 1> [로그파일명] 2>&1  &
        ```
    - 브라우저에서 `http://{서버 ip}:{port}`로 접근해보세요.

##### 1.1.2.4. 소스코드 배포, 빌드 및 실행

- [무료 도메인 사이트](https://xn--220b31d95hq8o.xn--3e0b707e/) 들을 활용하여 DNS 설정을 합니다.

### 1.2. 기능 요구사항 정리

|구분 | 상세 |구현방법     |
|:----:  |:------  |:---------|
|VPC 생성|• VCP 생성리|• CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성|
|Subnet 생성|• 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)<br>• 내부망으로 사용할 Subnet : 32개씩 1개<br>• 관리용으로 사용할 Subnet : 32개씩 1개| |
|Internet Gateway 연결|• Internet Gateway 연결| |
|Route Table 생성|• Route Table 생성| |
|Security Group 설정|• 외부망|• 전체 대역 : 8080 포트 오픈<br>• 관리망 : 22번 포트 오픈|
|Security Group 설정|• 내부망|• 외부망 : 3306 포트 오픈<br>• 관리망 : 22번 포트 오픈|
|Security Group 설정|• 관리망|• 자신의 공인 IP : 22번 포트 오픈|
|서버 생성|• 외부망에 웹 서비스용도의 EC2 생성<br>• 내부망에 데이터베이스용도의 EC2 생성<br>• 관리망에 베스쳔 서버용도의 EC2 생성<br>• 베스쳔 서버에 Session Timeout 600s 설정<br>• 베스쳔 서버에 Command 감사로그 설정| |

## 2. 분석 및 설계

### 2.1. 이번 Step 핵심 목표

#### 2.1.1. 서비스 구성하기

- 잘 모르는 분야겠지만 화이팅! :fire:

### 2.2. Todo List

- [x] 0.기본 세팅
    - [x] 0-1.git fork/clone
        - [x] 0-1-1.NEXTSTEP 내 과제로 이동 및 '미션시작'
        - [x] 0-1-2.실습 github으로 이동
        - [x] 0-1-3.branch 'gregolee'로 변경
        - [x] 0-1-4.fork
        - [x] 0-1-5.clone : `git clone -b gregolee --single-branch https://github.com/gregolee/infra-subway-deploy.git`
        - [x] 0-1-6.branch : `git checkout -b step1`
    - [x] 0-2.요구사항 정리
    - [x] 0-3.[AngularJS Commit Message Conventions](https://gist.github.com/stephenparish/9941e89d80e2bc58a153#generating-changelogmd) 참고
    - [x] 0-4.Slack을 통해 merge가 되는지 확인한 후에 코드 리뷰 2단계 과정으로 다음 단계 미션을 진행
        - [x] 0-4-1.gregolee(master) branch로 체크아웃 : `git checkout gregolee`
        - [x] 0-4-2.step1 branch 삭제 : `git branch -D step1`
        - [x] 0-4-3.step1 branch 삭제 확인 : `git branch -a`
        - [x] 0-4-4.원본(next-step) git repository를 remote로 연결 (미션 당 1회) : `git remote add -t gregolee upstream https://github.com/next-step/infra-subway-deploy`
        - [x] 0-4-5.원본(next-step) git repository를 remote로 연결 확인 : `git remote -v`
        - [x] 0-4-6.원본(next-step) git repository에서 merge된 나의 branch(gregolee)를 fetch : `git fetch upstream gregolee`
        - [x] 0-4-7.remote에서 가져온 나의 branch로 rebase : `git rebase upstream/gregolee`
        - [x] 0-4-7.gregolee -> step2로 체크아웃 : `git checkout -b step2`
    - [x] 0-5.리뷰어님의 리뷰를 반영한 코드로 수정
        - [x] 0-5-1.적용사항 없음
- [x] 1.자바 코드 컨벤션을 위한 세팅 (skip)
- [x] 2.학습
    - [x] 2-1.infra 강의 듣기
- [x] 3.분석 및 설계
    - [x] 3-1.step01.md 초안 작성
- [x] 4.구현
    - [x] 4-1.VPC 생성
        - [x] 4-1-1.CIDR은 C class(x.x.x.x/24)로 생성. 이 때, 다른 사람과 겹치지 않게 생성
    - [x] 4-2.Subnet 생성
        - [x] 4-2-1.외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
        - [x] 4-2-2.내부망으로 사용할 Subnet : 32개씩 1개
        - [x] 4-2-3.관리용으로 사용할 Subnet : 32개씩 1개
    - [x] 4-3.Internet Gateway 연결
    - [x] 4-4.Route Table 생성
    - [x] 4-5.Security Group 설정
        - [x] 4-5-1.외부망
            - [x] 4-5-1-1.전체 대역 : 8080 포트 오픈
            - [x] 4-5-1-2.관리망 : 22번 포트 오픈
        - [x] 4-5-2.내부망
            - [x] 4-5-2-1.외부망 : 3306 포트 오픈
            - [x] 4-5-2-2.관리망 : 22번 포트 오픈
        - [x] 4-5-3.관리망
            - [x] 4-5-3-1.자신의 공인 IP : 22번 포트 오픈
    - [x] 4-6.서버 생성
        - [x] 4-6-1.외부망에 웹 서비스용도의 EC2 생성
        - [x] 4-6-2.내부망에 데이터베이스용도의 EC2 생성
        - [x] 4-6-3.관리망에 베스쳔 서버용도의 EC2 생성
        - [x] 4-6-4.베스쳔 서버에 Session Timeout 600s 설정
        - [x] 4-6-5.베스쳔 서버에 Command 감사로그 설정
    - [x] 4-7.명령어
        - [x] 4-7-1.`nohup java -jar ./build/libs/subway-0.0.1-SNAPSHOT.jar  1> ./logs/infra-subway-deploy-20210628.log 2>&1  &`
        - [x] 4-7-2.root password : qwerty123456
- [x] 5.테스트
    - [x] 5-1.요구사항 조건들 충족했는지 확인
    - [x] 5-2.서버 확인
- [x] 6.인수인계
    - [x] 6-1.소감 및 피드백 정리
        - [x] 6-1-1.느낀점 & 배운점 작성
        - [x] 6-1-2.피드백 요청 정리
    - [x] 6-2.코드리뷰 요청 및 피드백
        - [x] 6-1-1.step1를 gregolee/atdd-subway-admin로 push : `git push origin step1`
        - [x] 6-1-2.pull request(PR) 작성
    - [x] 6-3.Slack을 통해 merge가 되는지 확인한 후에 미션 종료

### 2.3.적용 과정

#### 4-1.VPC

![vpc-01](../documents/step1/capture/vpc-01.jpg)
![vpc-02](../documents/step1/capture/vpc-02.jpg)
![vpc-03](../documents/step1/capture/vpc-03.jpg)
![vpc-04](../documents/step1/capture/vpc-04.jpg)

#### 4-2.Subnet

![subnet-01](../documents/step1/capture/subnet-01.jpg)
![subnet-02](../documents/step1/capture/subnet-02.jpg)
![subnet-03](../documents/step1/capture/subnet-03.jpg)

#### 4-3.Internet Gateway

![internet-gateway-01](../documents/step1/capture/internet-gateway-01.jpg)
![internet-gateway-02](../documents/step1/capture/internet-gateway-02.jpg)
![internet-gateway-03](../documents/step1/capture/internet-gateway-03.jpg)
![internet-gateway-04](../documents/step1/capture/internet-gateway-04.jpg)
![internet-gateway-05](../documents/step1/capture/internet-gateway-05.jpg)
![internet-gateway-06](../documents/step1/capture/internet-gateway-06.jpg)
![internet-gateway-07](../documents/step1/capture/internet-gateway-07.jpg)
![internet-gateway-08](../documents/step1/capture/internet-gateway-08.jpg)
![internet-gateway-09](../documents/step1/capture/internet-gateway-09.jpg)
![internet-gateway-10](../documents/step1/capture/internet-gateway-10.jpg)
![internet-gateway-11](../documents/step1/capture/internet-gateway-11.jpg)
![internet-gateway-12](../documents/step1/capture/internet-gateway-12.jpg)


#### 4-4.Route Table

![routing-table-01](../documents/step1/capture/routing-table-01.jpg)
![routing-table-02](../documents/step1/capture/routing-table-02.jpg)
![routing-table-03](../documents/step1/capture/routing-table-03.jpg)
![routing-table-04](../documents/step1/capture/routing-table-04.jpg)
![routing-table-05](../documents/step1/capture/routing-table-05.jpg)
![routing-table-06](../documents/step1/capture/routing-table-06.jpg)
![routing-table-07](../documents/step1/capture/routing-table-07.jpg)

#### 4-5.Security Group 설정

![security-01](../documents/step1/capture/security-01.jpg)
![security-02](../documents/step1/capture/security-02.jpg)
![security-03](../documents/step1/capture/security-03.jpg)
![security-04](../documents/step1/capture/security-04.jpg)
![security-05](../documents/step1/capture/security-05.jpg)
![security-06](../documents/step1/capture/security-06.jpg)
![security-07](../documents/step1/capture/security-07.jpg)

#### 4-6.서버 생성

##### 4-6-1~3. EC2 생성

![ec2-01](../documents/step1/capture/ec2-01.jpg)
![ec2-02](../documents/step1/capture/ec2-02.jpg)
![ec2-03](../documents/step1/capture/ec2-03.jpg)
![ec2-04](../documents/step1/capture/ec2-04.jpg)
![ec2-05](../documents/step1/capture/ec2-05.jpg)
![ec2-06](../documents/step1/capture/ec2-06.jpg)
![ec2-07](../documents/step1/capture/ec2-07.jpg)
![ec2-08](../documents/step1/capture/ec2-08.jpg)
![ec2-09](../documents/step1/capture/ec2-09.jpg)
![ec2-10](../documents/step1/capture/ec2-10.jpg)
![ec2-11](../documents/step1/capture/ec2-11.jpg)
![ec2-12](../documents/step1/capture/ec2-12.jpg)


## 3. 인수인계

### 3.1. 느낀점 & 배운점

#### 3.1.1. 느낀점

- AWS 인스턴스 관리가 상당히 까다롭고 힘들다는 것을 배웠습니다.
    - 쉽다면 쉽게 접근할 수 있고, 어렵다면 어렵게 접근할 수 있는 주제였습니다.
    - 정말 수월하게 풀리면 초기 세팅을 제외하면 리눅스 명령어로 인해 쉽게 진행이 가능했습니다.
    - 그러나 베스쳔을 적용하는 과정에서 `authorized_keys`를 변경함으로 인하여 인스턴스에 직접 접근을 못하는 상황이 발생했습니다.
        - 해결 방법은 아래 배운점에 링크로 남겨두었습니다.
        - 해결은 되었지만...정말 식겁했습니다.
    - AWS 정말 잘 써보고 싶다는 생각이 드는 좋은 시스템인 것 같습니다!

#### 3.1.2. 배운점

- AWS 체험하기
    - VPC, EC2, 서브넷, 라우터, 대역 등등 경험해서 조금이라도 네트워크와 친숙해진 것 같습니다.
    - 보다 더 잘 활용하기 위해서는 네트워크에 대한 이해가 많아야 된다고 뼈저리게 느꼈습니다.
- authorized_keys 를 잘못관리하여 인스턴스에 접근하지 못하는 상황
    - 우회적인 방법으로 키 파일명을 원상복구하여 접근할 수 있도록 했습니다.
    - 참조
        - [키 페어 분실시 복구법 - 복구할 볼륨 마운트 방법](https://blog.nuricloud.com/ec2-key-pair-%EB%B6%84%EC%8B%A4/)
        - [마운트 문제 해결](https://www.linuxquestions.org/questions/linux-newbie-8/mount-mnt-disk-wrong-fs-type-bad-option-bad-superblock-on-dev-mapper-vg-lv-4175632012/)

### 3.2. 피드백 요청

- 이번 단계에서는 피드백 요청은 없습니다.
