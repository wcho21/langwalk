FROM ubuntu:24.10

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get --yes install gcc-riscv64-linux-gnu qemu-user && apt-get clean
