# README

RISC-V 어셈블리 예시 코드.

## 사용법

소스 코드가 위치한 디렉토리 `src`에서 컴파일하고 실행.

```shellsession
$ cd src
$ riscv64-linux-gnu-gcc -nostdlib -static -march=rv64g -mabi=lp64d empty.S
$ ./a.out
```

## 실행 환경

리눅스 환경에서 크로스 컴파일러인 `gcc`가 필요하며, 다음과 같이 실행 환경을 구축할 수 있음.

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

이후 리눅스에서 RISC-V 크로스 컴파일러 `gcc`, 가상 머신 `qemu` 설치.

### 그 외 (Linux, Mac)

패키지 매니저로 RISC-V 크로스 컴파일러 `gcc`, 가상 머신 `qemu` 설치.

우분투 리눅스에서는 다음과 같은 패키지 설치.

```shellsession
$ apt-get install gcc-riscv64-linux-gnu qemu-user
```
