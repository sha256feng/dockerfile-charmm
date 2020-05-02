FROM ubuntu:20.04

RUN \
        apt-get update \
        && apt-get install -yq \
        wget \
        g++ \
        gfortran \
        libssl-dev \
        make

# Get CHARMM folder
RUN \
        wget --load-cookies /tmp/cookies.txt \
        "https://docs.google.com/uc?export=download&confirm=$(wget \
        --quiet --save-cookies /tmp/cookies.txt \
        --keep-session-cookies --no-check-certificate \
        'https://docs.google.com/uc?export=download&id=1lsuVDXhHpD8cuTrdJ89AR1P0p8eHye0Q' \
        -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1lsuVDXhHpD8cuTrdJ89AR1P0p8eHye0Q" \
        -O charmm.tar.gz \
        && rm -rf /tmp/cookies.txt

RUN \
        tar xf charmm.tar.gz

# Install Cmake
RUN \
        wget https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2.tar.gz \
        && tar xf cmake-3.17.2.tar.gz \
        && cd cmake-3.17.2 \
        && ./bootstrap \
        && make \
        && make install

# Install CHARMM
RUN \
        cd /charmm \
        && ./configure -l \
        && cd build/cmake \
        && make \
        && make install \
        && mv /charmm/bin/charmm /usr/local/bin/ \
        && cd / \
        && rm -rv charmm charmm.tar.gz cmake-3.17.2.tar.gz

ENV PATH="/usr/local/bin/:$PATH"

CMD ["/bin/bash"]
