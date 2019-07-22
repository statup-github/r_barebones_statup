FROM stefanfritsch/baseimage_statup:1.0.2
MAINTAINER Stefan Fritsch <stefan.fritsch@stat-up.com>

ENV RVERSION="3.5.3"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN apt-get update \
  && apt-get install -y --no-install-recommends wget \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    default-jdk \
    dnsutils \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    git \
    gsfonts \
    icedtea-netx \
    libapparmor1 \
    libblas-dev \
    libbz2-1.0 \
    libbz2-dev \
    libc-dev \
    libc-dev-bin \
    libcairo2-dev \
    libcurl4 \
    libcurl4-openssl-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libicu-dev \
    libicu60 \
    libjpeg-dev \
    libjpeg62 \
    liblzma-dev \
    liblzma5 \
    libopenblas-dev \
    libpango1.0-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    libpcre3-dev \
    libpng16-16 \
    libpng-dev \
    libproj-dev \
    libreadline-dev \
    libreadline7 \
    librsvg2-dev \
    libssl-dev \
    libtiff5 \
    libtiff5-dev \
    libudunits2-0 \
    libudunits2-dev \
    libx11-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxslt1-dev \
    libxt-dev \
    libxt-dev \
    linux-libc-dev \
    locales \
    lsb-release \
    make \
    mdbtools \
    multiarch-support \
    nano \
    netcdf-bin \
    psmisc \
    python-setuptools \
    sudo \
    unzip \
    wget \
    zip \
    zlib1g \
    zlib1g-dev
    

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN update-locale

ENV CURL_CA_BUNDLE=/opt/microsoft/ropen/${RVERSION}/lib64/R/lib/microsoft-r-cacert.pem

RUN cd /opt \
    && echo "CURL_CA_BUNDLE=/opt/microsoft/ropen/${RVERSION}/lib64/R/lib/microsoft-r-cacert.pem" >> /etc/profile \
    && wget https://mran.blob.core.windows.net/install/mro/${RVERSION}/ubuntu/microsoft-r-open-${RVERSION}.tar.gz \
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
