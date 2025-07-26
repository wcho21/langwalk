# README

할 일 관리 프로그램의 Bash 소스 코드.

## 사용법

소스 코드가 위치한 디렉토리 `src`에서 실행.

```shellsession
$ cd src
$ ./todo add <task> [tasks...]
$ ./todo list
$ ./todo remove <task-id>
```

## 실행 환경

리눅스 환경의 Bash 셸이 필요하며, 다음과 같이 실행 환경을 구축할 수 있음.

### 데브 컨테이너 (권장)

다음과 같은 방법으로 가상 환경을 실행할 수 있음.

1. [*Docker*][docker] 설치. (가상 환경에 필요)
1. [*Visual Studio Code*][vscode] 설치. (에디터로서 필요)
1. *Visual Studio Code* 실행 후, *Dev Container* 익스텐션 설치.
1. `F1` 누른 후, `Open Folder in Container` 타이핑하여 실행.
1. 이 디렉토리를 선택해 데브 컨테이너 실행.

[vscode]: https://code.visualstudio.com
[docker]: https://www.docker.com

필요한 것은 컨테이너에 이미 설치되어 있으므로 그대로 사용. (`.devcontainer/` 디렉토리 참고)

### Windows

다음과 같은 방법으로 리눅스 환경을 실행할 수 있음.

- [*Cygwin*][cygwin] 같은 리눅스 환경 설치.
- [*Linux Subsystem Linux (WSL)*][wsl] 같은 가상 리눅스 환경 설치.

[cygwin]: https://cygwin.com
[wsl]: https://learn.microsoft.com/ko-kr/windows/wsl/install

### 그 외 (Linux, Mac)

기존에 설치된 Bash 셸을 그대로 사용하거나, 패키지 매니저로 최신 버전 사용.
