FROM ccob/windows_cross:latest

# update sources

RUN echo "deb http://old-releases.ubuntu.com/ubuntu impish main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://old-releases.ubuntu.com/ubuntu impish-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://old-releases.ubuntu.com/ubuntu impish-security main restricted universe multiverse" >> /etc/apt/sources.list

# create dirs

RUN mkdir /app
RUN mkdir /tools

# copy some stupid packages across

COPY toolchain/mingw-w64-common_10.0.0-3_all.deb /tools
COPY toolchain/packages-microsoft-prod.deb /tools

# Install deps, mingw and ms packages (adds dotnet packages)
RUN dpkg -i /tools/mingw-w64-common_10.0.0-3_all.deb
RUN dpkg -i /tools/packages-microsoft-prod.deb

# install all the things
RUN apt-get update
RUN apt -y install software-properties-common dotnet-sdk-8.0 cmake zip wamerican-small

WORKDIR /app
