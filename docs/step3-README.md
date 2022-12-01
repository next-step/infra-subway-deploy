# Step2. 배포 ㅅ크립트 작성하기

# 목표

### 배포 스크립트 작성

- 정상적으로 배포하는 스크립트 작성

### 개발 환경 구성하기

- profile 별 설정 파일 분리
    - test : h2
    - local : docker(mysql)
    - prod : 운영 DB

# TODO List

- [ ] 반복 사용 명령어 Script 로 작성
  - [ ] 소스코드 변경 체크
  - [ ] 소스코드 pull
  - [ ] gradle build
  - [ ] 기존 프로세스 종료
  - [ ] 어플리케이션 실행
- [ ] 사용자의 답변 받아보기
- [ ] 반복적으로 동작하는 스크립트 작성

### Shell Script
#### read
- `read` 를 통해 사용자에게 입력값 받기 가능
- [Guide to the Linux read Command](https://www.baeldung.com/linux/read-command)

#### kill
- 프로세스 종료
- `kill -l` 명령어로 종류 확인 가능
  ```shell
  $ kill -0 {PID}   # 종료 되었는지 확인
  $ kill -9 {PID}   # 강제 종료 - sigkill
  $ kill -15 {PID}  # 종료 - sigterm
  ```

#### pgrep
- 프로세스 ID 확인
- `pgrep -f {프로세스명}`

#### crontab vs /etc/crontab
- crontab
  - 사용자가 crontab 명령어로 등록한 스케줄
  - `crontab -e` 로 설정 가능
  - ```shell
    # crontab -e
    # 매일 0시 0분 0초에 실행
    0 0 0 * * * /home/ubuntu/deploy.sh
    
    # 1분마다 실행
    * * * * * * /home/ubuntu/deploy.sh
  
    # 형식
    # m h  dom mon dow  command
      * *  *   *   *    some_command
    ```
- /etc/crontab
  - root 계정이 등록한 스케줄 - 사용자별 설정 가능
  - `vi /etc/crontab` 로 설정 가능
  - root 권한 필요
  - ```shell
    # vi /etc/crontab
    # 매일 0시 0분 0초에 실행
    0 0 0 * * * root /home/ubuntu/deploy.sh
    
    # 1분마다 실행
    * * * * * * root /home/ubuntu/deploy.sh
  
    # 형식
    # m h dom mon dow user      command
      * * *   *   *   someuser  some_command
    ```
- [crontab vs /etc/crontab](https://stackoverflow.com/questions/22203120/cronjob-entry-in-crontab-e-vs-etc-crontab-which-one-is-better)