FROM circleci/node:8

RUN sudo apt-get update && \
sudo apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget python-pip gettext && \
sudo wget https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb && \
sudo dpkg -i dumb-init_*.deb && sudo rm -f dumb-init_*.deb && \
sudo apt-get clean && \
sudo apt-get autoremove -y && \
sudo rm -rf /var/lib/apt/lists/*

# Kubectl
RUN sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN sudo chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl

# AWS
RUN sudo pip install awscli

# Puppeteer
RUN sudo yarn global add puppeteer@1.8.0 && yarn cache clean

# Sentry CLI
RUN sudo curl -sL https://sentry.io/get-cli/ | bash

ENV NODE_PATH="/usr/local/share/.config/yarn/global/node_modules:${NODE_PATH}"

ENV PATH="/tools:${PATH}"

RUN sudo groupadd -r pptruser && sudo useradd -r -g pptruser -G audio,video pptruser

COPY --chown=pptruser:pptruser ./tools /tools

# Set language to UTF8
ENV LANG="C.UTF-8"

WORKDIR /app

# Add user so we don't need --no-sandbox.
RUN sudo mkdir /screenshots \
	&& sudo mkdir -p /home/pptruser/Downloads \
    && sudo chown -R pptruser:pptruser /home/pptruser \
    && sudo chown -R pptruser:pptruser /usr/local/share/.config/yarn/global/node_modules \
    && sudo chown -R pptruser:pptruser /screenshots \
    && sudo chown -R pptruser:pptruser /app \
    && sudo chown -R pptruser:pptruser /tools

# Run everything after as non-privileged user.
USER pptruser

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "index.js"]