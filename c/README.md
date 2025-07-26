# README

할 일 관리 프로그램의 C 소스 코드.

## 사용법

소스 코드가 위치한 디렉토리 `src`에서 컴파일하고 실행.

```
$ cd src
$ gcc -std=gnu17 todo.c task.c -o todo
$ ./todo add <task>
$ ./todo list
```

## 실행 환경

리눅스 환경에서 C 컴파일러인 `gcc`가 필요하며, 다음과 같이 실행 환경을 구축할 수 있음.

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

이후 리눅스에서 `gcc` 설치.

### 그 외 (Linux, Mac)

패키지 매니저로 `gcc` 설치.
맥에서는 또 다른 C 컴파일러인 `clang`을 대신 사용할 수 있음.
