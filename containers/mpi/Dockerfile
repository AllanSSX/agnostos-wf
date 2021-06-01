FROM ubuntu:latest

RUN export DEBIAN_FRONTEND="noninteractive" && apt-get -y update && apt-get -y install build-essential cmake xxd git zlib1g-dev libbz2-dev libatomic1 openmpi-bin libopenmpi-dev wget git tar

WORKDIR /opt/src

# Install MMSeqs2
RUN git clone https://github.com/soedinglab/MMseqs2.git; \
    cd MMseqs2; \
    git checkout 2f1db01c5109b07db23dc06df9d232e82b1b4b99; \
    mkdir build; \
    cd build; \
    cmake -DHAVE_MPI=1 -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/opt/mmseqs2 ..; \
    make -j 2; \
    make install

# Install HMMER
RUN wget http://eddylab.org/software/hmmer/hmmer-3.3.tar.gz; \
    tar zxf hmmer-3.3.tar.gz; \
    cd hmmer-3.3; \
    ./configure --prefix=/opt/hmmer --enable-mpi; \
    make -j 2; \
    make check; \
    make install

# Install FAMSA (multiple sequence alignments)
RUN mkdir -p /opt/famsa/bin/; \
    wget https://github.com/refresh-bio/FAMSA/releases/download/v1.2.1/famsa-1.2.1-linux -O /opt/famsa/bin/famsa; \
    chmod +x /opt/famsa/bin/famsa

# Install OD-seq (Outlier detection in multiple sequence alignments)
RUN wget http://www.bioinf.ucd.ie/download/od-seq.tar.gz; \
    tar -zxf od-seq.tar.gz; \
    cd OD-Seq/; \
    mkdir -p /opt/OD-Seq/bin; \
    g++ -fopenmp -o /opt/OD-Seq/bin/OD-seq AliReader.cpp Bootstrap.cpp DistCalc.cpp DistMatReader.cpp DistWriter.cpp FastaWriter.cpp IQR.cpp ODseq.cpp PairwiseAl.cpp Protein.cpp ResultWriter.cpp runtimeargs.cpp util.cpp

# Install HHblits
RUN git clone https://github.com/soedinglab/hh-suite; \
    cd hh-suite; \
    git submodule init; \
    git submodule update; \
    mkdir build; \
    cd build; \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/opt/hh-suite ..; \
    make -j 2; \
    make install

# Install FFindex (mpi mode)
RUN git clone https://github.com/soedinglab/ffindex_soedinglab; \
    cd ffindex_soedinglab; \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/opt/ffindex .; \
    make -j 8; \
    make install

# Install Kaiju
RUN git clone https://github.com/bioinformatics-centre/kaiju.git; \
    cd kaiju/src; \
    make -j 2; \
    cd ../ ; \
    mkdir -p /opt/kaiju/bin/; \
    cp bin/* /opt/kaiju/bin/

# Export bin
ENV PATH=/opt/mmseqs2/bin:/opt/hmmer/bin:/opt/famsa/bin:/opt/OD-Seq/bin:/opt/hh-suite/bin:/opt/hh-suite/scripts:/opt/hh-suite/data:/opt/ffindex/bin:/opt/kaiju/bin/:$PATH
