# Used ports 8082, 8080
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y --no-install-recommends curl wget ca-certificates git && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "--login","-i", "-c"]
#RUN apt-get update && apt-get upgrade -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
ENV NVM_DIR /root/.nvm
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && apt-get clean && apt-get autoremove -y
RUN source /root/.bashrc && nvm install 14 && nvm alias default 14 && nvm use default
ENV NODE_PATH $NVM_INSTALL_PATH/lib/node_modules
ENV PATH $NVM_INSTALL_PATH/bin:$PATH
RUN wget -O "/tmp/websocat_1.7.0_ssl1.1_amd64.deb" "https://github.com/vi/websocat/releases/download/v1.7.0/websocat_1.7.0_ssl1.1_amd64.deb" && dpkg -i /tmp/websocat_1.7.0_ssl1.1_amd64.deb
WORKDIR /root/
EXPOSE 8082
EXPOSE 8080
RUN git clone --branch develop https://github.com/Levi--G/mqp-server.git && mv mqp-server mqp
WORKDIR /root/mqp
RUN rm -f ./socketserver/db && mkdir ./socketserver/db && mkdir -p /mnt/config && rm -f ./config.hjson && ln -s /mnt/config/config.hjson ./config.hjson && rm -f ./log.txt 2>/dev/null && ln -s /mnt/config/log.txt ./log.txt && git pull && npm install && ln -s /config/start.sh /root/mqp/start.sh
CMD bash /mnt/config/start.sh
