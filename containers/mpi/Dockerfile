FROM ubuntu:latest

RUN apt-get -y update && apt-get -y install build-essential cmake xxd git zlib1g-dev libbz2-dev libatomic1 openmpi-bin libopenmpi-dev wget git

WORKDIR /opt/src

RUN mkdir bin

RUN git clone https://github.com/soedinglab/MMseqs2.git; \
    cd MMseqs2; \
    git checkout 2f1db01c5109b07db23dc06df9d232e82b1b4b99; \
    mkdir build; \
    cd build; \
    cmake -DHAVE_MPI=1 -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/opt/src/bin ..; \
    make -j 8; \
    make install; \
    cd ..; \

ENV PATH /opt/src/bin:$PATH
