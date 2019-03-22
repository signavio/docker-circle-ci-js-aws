FROM alekzonder/puppeteer:1.1.1

# switch user to root because pptruser defined in the base image is a non-privileged user 
USER root

# Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN export PATH=$PATH:/usr/local/bin/kubectl

# AWS
RUN apt update 
RUN apt install -y python3-pip
RUN pip3 install awscli
