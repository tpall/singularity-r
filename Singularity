BootStrap: docker
From: debian:buster

%labels
  Maintainer tpall
  R_Version 4.0.3

%apprun R
  exec R "${@}"

%apprun Rscript
  exec Rscript "${@}"

%runscript
  exec R "${@}"

%environment
  LC_ALL=en_US.UTF-8
  LANG=en_US.UTF-8
  TERM=xterm
  export LC_ALL LANG TERM

%post
  # Software versions
  export R_VERSION=${R_VERSION:-4.0.3}
  export BUILD_DATE=${BUILD_DATE:-2020-12-15}
  export CRAN=${CRAN:-http://cran.rstudio.com}

 # Get dependencies
  apt-get update \
  && apt-get install -y --no-install-recommends \
    locales

  # Configure default locale
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen en_US.utf8
  /usr/sbin/update-locale LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  
  # Configure term
  export TERM=xterm

  # Install R
  apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    devscripts \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl4 \
    libicu63 \
    libpcre2-dev \
    libjpeg62-turbo \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpng16-16 \
    libreadline7 \
    libtiff5 \
    liblzma5 \
    locales \
    make \
    unzip \
    zip \
    zlib1g \
  && BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    rsync \
    subversion \
    tcl8.6-dev \
    tk8.6-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    texlive-latex-extra \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    wget \
    zlib1g-dev" \
  && apt-get install -y --no-install-recommends $BUILDDEPS \
  && cd tmp/
  
  ## Download source code
  curl -O http://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz
  
  ## Extract source code
  tar -xf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION}
  
  ## Set compiler flags
  R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g"
  
  ## Configure options
  ./configure --enable-R-shlib \
               --enable-memory-profiling \
               --with-readline \
               --with-blas \
               --with-tcltk \
               --disable-nls \
               --with-recommended-packages
  
  ## Build and install
  make \
  && make install
  
  ## Add a library directory (for user-installed packages)
  mkdir -p /usr/local/lib/R/site-library
  
  ## Set site library path
  echo "R_LIBS_SITE='/usr/local/lib/R/site-library'" >> /usr/local/lib/R/etc/Renviron
  
  ## Install packages from date-locked MRAN snapshot of CRAN
  if [ -z "$BUILD_DATE" ]; then MRAN=$CRAN; \
  else MRAN=http://mran.microsoft.com/snapshot/${BUILD_DATE}; fi \
  && echo MRAN=$MRAN >> /etc/environment \
  && export MRAN=$MRAN \
  && echo "options(repos = c(CRAN = '$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
  
  ## Install remotes package
  Rscript -e "install.packages(c('remotes'), repo = '$MRAN')"
  
  ## Clean up from R source install
  cd / \
  && rm -rf /tmp/*.rds \
  && apt-get remove --purge -y $BUILDDEPS \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/*
