# Step3. 배포 스크립트 작성하기
===

# 요구사항
배포 스크립트 작성하기
  - 앞선 step1, step2 과정에서 배포 시 수동으로 진행했던 내용을 스크립트로 작성하여 자동화
    
---
# TODO List
### 앞선 두 단계에서 수동으로 진행한 명령어 정리
- git clone 
  - git clone -b mission/step2 --single-branch https://github.com/choi-ys/infra-subway-deploy.git

- gradle build
  - ./gradlew clean test
  - ./gradlew clean build
  
- kill process
  - pgrep java
  - kill -15(SIGTERM) {pid}
   
- deploy
  - nohup java -jar -Dspring.profiles.active=prod subway-0.0.1-SNAPSHOT.jar 1> infra-subway-deploy-log 2>&1 &

### 수동 업무 자동화를 위한 스크립트 작성
- [x] repo head revision 비교
- [x] git pull
- [x] gradle build
- [x] kill process : 강제종료(kill -9)가 아닌 종료 요청(kill -15)을 이용한 자원 정리
- [x] deploy service

---
### 참고 URL
[LINUX : KILL 프로세스를 ‘안전하게’ 종료시키기](https://www.jp-hosting.jp/linux-kill-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4%EB%A5%BC-%EC%95%88%EC%A0%84%ED%95%98%EA%B2%8C-%EC%A2%85%EB%A3%8C%EC%8B%9C%ED%82%A4%EA%B8%B0/)
```
$ kill -l
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX 
```

[Git-도구-리비전-조회하기](https://git-scm.com/book/ko/v2/Git-%EB%8F%84%EA%B5%AC-%EB%A6%AC%EB%B9%84%EC%A0%84-%EC%A1%B0%ED%9A%8C%ED%95%98%EA%B8%B0)


