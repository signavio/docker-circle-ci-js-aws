FROM circleci/openjdk:9
RUN sudo apt-get update && sudo apt-get install gettext docker python-pip python-setuptools wget curl apt-transport-https

# Kubectl
RUN sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN sudo chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl

# AWS
RUN sudo pip install awscli

# Azure