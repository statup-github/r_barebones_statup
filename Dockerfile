FROM stefanfritsch/baseimage_statup:0.11
MAINTAINER Stefan Fritsch <stefan.fritsch@stat-up.com>

ENV RVERSION="3.5.1"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN apt-get update \
  && apt-get install -y --no-install-recommends wget \
  && export DEBIAN_FRONTEND=noninteractive \
  && wget https://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && apt-get install -y --no-install-recommends linux-libc-dev libc-dev zlib1g-dev libc-dev-bin \
  && wget https://mirrors.edge.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-dev_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i libpng12-dev_1.2.54-1ubuntu1_amd64.deb \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl4 \
    libicu60 \
    libjpeg62 \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    libreadline7 \
    libtiff5 \
    liblzma5 \
    locales \
    make \
    unzip \
    zip \
    zlib1g \
    file \
    git \
    libapparmor1 \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    python-setuptools \
    sudo \
    wget \
    multiarch-support \
    libudunits2-dev \
    libudunits2-0 \
    dnsutils \
    bzip2 \
    nano \
    icedtea-netx \
    libgdal-dev \
    libproj-dev \
    libgeos-dev \
    libgsl0-dev \
    librsvg2-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxslt1-dev \
    libxt-dev \
    mdbtools \
    netcdf-bin \
    curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre3-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    build-essential
    

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN update-locale

ENV CURL_CA_BUNDLE=/opt/microsoft/ropen/${RVERSION}/lib64/R/lib/microsoft-r-cacert.pem

RUN cd /opt \
    && echo "CURL_CA_BUNDLE=/opt/microsoft/ropen/${RVERSION}/lib64/R/lib/microsoft-r-cacert.pem" >> /etc/profile \
    && wget https://mran.blob.core.windows.net/install/mro/${RVERSION}/microsoft-r-open-${RVERSION}.tar.gz \
    && tar -xf microsoft-r-open-${RVERSION}.tar.gz \
    && rm microsoft-r-open-${RVERSION}.tar.gz \
    && cd microsoft-r-open/ \
    && ./install.sh -a -u \
    && cd .. \
    && rm -r microsoft-r-open \
    && chmod -R 0777 /opt/microsoft/ropen/${RVERSION}/lib64/R/library \
    && chmod -R 0777 /opt/microsoft/ropen/${RVERSION}/lib64/R/doc/html

RUN CURL_CA_BUNDLE=/opt/microsoft/ropen/${RVERSION}/lib64/R/lib/microsoft-r-cacert.pem \
    && Rscript -e 'install.packages(c("httr", "curl"))'

RUN Rscript -e 'install.packages("devtools")'

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3838

CMD ["/sbin/my_init"]
