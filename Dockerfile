FROM ubuntu:14.04
LABEL maintainer "Dave Larson <delarson@wustl.edu>"

# Build dependencies
RUN buildDeps=' \
        git-core \
        ca-certificates \
        python \
        ' \
    && runDeps=' \
        ca-certificates \
        libnss-sss \
        python-pycurl \
        python-dateutil \
        python \
        ' \
    && apt-get update -qq \
    && apt-get -y install \
        --no-install-recommends \
        $buildDeps \
    && git clone https://github.com/basespace/basespace-python-sdk.git \
    && cd basespace-python-sdk/src \
    && python setup.py install \
    && cd ../.. \
    && rm -rf basespace-python-sdk \
    && AUTO_ADDED_PACKAGES=`apt-mark showauto` \
    && apt-get purge -y --auto-remove $buildDeps $AUTO_ADDED_PACKAGES \
    && apt-get install -y $runDeps \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
