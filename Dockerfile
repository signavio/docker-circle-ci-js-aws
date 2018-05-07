FROM circleci/openjdk:9
RUN sudo apt-get update && sudo apt-get install gettext docker python-pip python-setuptools wget
RUN sudo wget -q https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubectl && sudo chmod +x kubectl && sudo mv kubectl /usr/bin
RUN sudo wget -q https://github.com/kubernetes/kops/releases/download/1.6.1/kops-linux-amd64 && sudo chmod +x kops-linux-amd64 && sudo mv kops-linux-amd64 /usr/bin/kops
RUN sudo mkdir -p /usr/lib/gradle
ENV GRADLE_VERSION 4.1
ENV GRADLE_HOME /usr/lib/gradle/gradle-${GRADLE_VERSION}
ENV PATH ${PATH}:${GRADLE_HOME}/bin
WORKDIR /usr/lib/gradle
RUN set -x \
    && sudo wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && sudo unzip gradle-${GRADLE_VERSION}-bin.zip \
    && sudo rm gradle-${GRADLE_VERSION}-bin.zip
RUN sudo pip install awscli
