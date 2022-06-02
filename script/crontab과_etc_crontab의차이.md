Crontab을 둥록하는 방법은 두가지가 있다. 
1. vi /etc/crontab
2. crontab -e

이 둘은 동일하게 특정 주기에 따라 실행해야 하는 작업을 정의하는 것이다.
근데 왜 두가지가 있을까?

### root 권한이 있는 경우 - /etc/crontab 편집

root 권한이 있는 경우 /etc/crontab 파일을 편집한다.
/etc/crontab 을 확인해보면 아래와 같이 설명되어 있다.
"시스템 전반에 관여하는 크론탭이다. 다른 크론탭과 달리 사용자명을 적는 필드가 있다."
SHELL은 cron을 실행할 쉘을 적어주는 부분이고
PATH는 cron을 실행할 때의 $PATH 이다.

```
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
```

### root 권한이 없는 경우 crontab -e
root 권한이 없는 경우에는 crontab -e 를 이용한다.
환경변수에 에디터가 설정되어 있지 않으면 어떤 에디터를 사용할 것인지 확인한다.
(추천으로 nano를!!)

/etc/crontab 과 달리 username 열이 존재하지 않는다.


---
### cron이 참조하는 crontab 파일 위치
```
/var/spool/cron
/etc/cron.d
/etc/crontab
```
cron은 시작할 때 모든 곳에 저장된 설정파일들을 읽어 메모리에 저장해두고 휴지 상태에 들어간다. 
그리고 매분마다 활성화돼 변경된 crontab 파일들이 있는지 확인하고, 
변경된 경우 설정을 다시 읽어 저장하고, 
그 시간에 실행해야 할 작업이 있는지 확인하고 실행시킨 후 다시 휴지 상태로 들어간다.

### /var/spool/cron
시스템 개별 사용자를 위한 crontab 파일 위치이며 일반적으로 root 계정용 하나와 계정 사용자당 1개의 파일을 가진다.

파일명은 사용자의 계정명이며 cron은 이 이름을 바탕으로 각 설정 파일에 지정된 작업들을 실행할 때 사용할 UID를 결정한다. 
이 곳에 있는 설정파일들은 crontab 명령으로 관리한다.

