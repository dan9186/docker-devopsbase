FROM centos:7

ARG GIT_COMMIT_HASH
ARG VERSION

LABEL org.metadata.version=$VERSION \
	   org.metadata.name="Devops Base Image" \
	   org.metadata.description="A base image for personalized docker environments with several devopsy tools installed." \
	   org.metadata.url="https://github.com/dan9186/docker-devopsbase" \
	   org.metadata.vcs-url="https://github.com/dan9186/docker-devopsbase" \
	   org.metadata.vcs-sha=$GIT_COMMIT_HASH

# Add repos
RUN rpm -Uvh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Install Packages
RUN yum -y install epel-release && \
    yum -y update && \
    yum -y upgrade && \
    yum install -y \
					ack autoconf automake \
					bind-utils bison bzip2 bzr \
					cmake curl \
					file-devel \
					jq \
					libcurl-devel libffi-devel libicu-devel libpqxx-devel libtool libxml2-devel libxslt-devel libyaml-devel libtool-ltdl-devel \
					gcc-c++ git \
					make man maven mercurial \
					nmap nmap-ncat nodejs npm net-tools \
					patch postgresql96-devel postgresql-devel python-devel python-pip \
					readline-devel \
					sqlite-devel \
					tar \
					unzip \
					vim \
					wget \
					xmlsec1-openssl-devel \
					&& \
    yum clean all

WORKDIR /tmp

# Install Golang
COPY --from=golang:stretch /usr/local/go /usr/local/go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
RUN mkdir /go

# Upgrade Pip
RUN pip install --upgrade pip

# Install RVM
ENV RVM_VERSION 1.29.9
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
    wget "https://github.com/rvm/rvm/archive/$RVM_VERSION.tar.gz" && \
    tar xvf "$RVM_VERSION.tar.gz" && \
    cd "rvm-$RVM_VERSION" && \
    ./install && \
    cd /tmp && \
    rm -rf "$RVM_VERSION.tar.gz" "rvm-$RVM_VERSION" && \
    echo "bundler" >> /usr/local/rvm/gemsets/global.gems

# Install Packer
RUN wget https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip -O packer.zip && \
    unzip packer.zip && \
    rm packer.zip && \
    mv packer* /usr/local/bin/

# Install Python Items
RUN pip install awscli

# Install NPM Items
RUN npm install -g \
	less

WORKDIR /
