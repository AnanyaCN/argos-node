FROM harbor.distributedlearning.ai/infrastructure/base

LABEL version="0.0.1"
LABEL infrastructure_version = "1.0.0"
LABEL maintainer="Frank Martin <f.martin@iknl.nl>, Melle Sieswerda <m.sieswerda@iknl.nl>"

COPY . /vantage6
WORKDIR /vantage6

RUN apt-get -y update
RUN apt-get -y install git

RUN python -m pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-common
RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-client
RUN pip install --target /vantage6 git+https://github.com/iknl/vantage6-server
RUN pip install -e . 


# copy start file to app folder

# expose the proxy server port
ARG port=80
EXPOSE ${port}
ENV PROXY_SERVER_PORT ${port}
