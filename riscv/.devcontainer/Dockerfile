FROM ubuntu:24.10

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get --yes install git vim gnupg2 build-essential && apt-get clean