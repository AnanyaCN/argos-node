FROM harbor.vantage6.ai/infrastructure/base

LABEL version="2.0"
LABEL infrastructure_version = "2.0.0"
LABEL maintainer="Frank Martin <f.martin@iknl.nl>, Melle Sieswerda <m.sieswerda@iknl.nl>"


# Enable SSH access in Azure App service
RUN apt update -y
RUN apt upgrade -y
RUN apt install openssh-server sudo -y
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN  echo 'root:Docker!' | chpasswd
COPY sshd_config /etc/ssh/
RUN mkdir /run/sshd

# Fix DB issue
RUN apt install python-psycopg2 -y
RUN pip install psycopg2-binary

COPY . /vantage6
WORKDIR /vantage6

RUN apt-get -y update
RUN apt-get -y install git

RUN python -m pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN pip install gunicorn==19.9.0
RUN pip install gevent==20.9.0
RUN pip install greenlet==0.4.13

RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-common
RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-client
RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-server
RUN pip install -e /vantage6/vantage6-node



# copy start file to app folder

# expose the proxy server port
ARG port=80
EXPOSE ${port}
ENV PROXY_SERVER_PORT ${port}
