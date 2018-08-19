FROM ubuntu:xenial
MAINTAINER contributors

VOLUME /data
WORKDIR /data

# Install libraries for building mapbox-gl-native
# References:
#   https://github.com/mapbox/mapbox-gl-native/blob/master/platform/linux/README.md#prerequisites
RUN apt-get -qq update \
&&  apt-get -y install \
    apt-transport-https \
    gcc-4.9 g++-4.9 \
    cmake cmake-data \
    curl git build-essential zlib1g-dev automake \
    libtool xutils-dev make pkg-config python-pip \
    libcurl4-openssl-dev libpng-dev libsqlite3-dev \
    libllvm3.9 \
    libxi-dev libglu1-mesa-dev x11proto-randr-dev \
    x11proto-xext-dev libxrandr-dev \
    x11proto-xf86vidmode-dev libxxf86vm-dev \
    xvfb \
    libxcursor-dev libxinerama-dev

# Install yarn
# References:
#   https://yarnpkg.com/en/docs/install#debian-rc 
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN  echo "deb https://dl.yarnpkg.com/debian/ rc main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -qq update \
&&  apt-get -y install yarn

# Install node 8
# Reference: 
#   https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -qq update \
&&  apt-get -y install nodejs \
&& apt-get clean

ADD package.json yarn.lock /tmp/
ADD src/ /tmp/src/
RUN yarn global add mbgl-renderer

