# hadolint ignore=DL3007
FROM myoung34/github-runner-base:ubuntu-bionic
LABEL maintainer="myoung34@my.apsu.edu"

ARG GH_RUNNER_VERSION="2.263.0"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner


RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh
RUN mkdir /opt/hostedtoolcache \
  && chown 1001:docker /opt/hostedtoolcache/

# Install yarn 
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update && DEBIAN_FRONTEND=noninteractive apt --yes install yarn
  
# Install wget 
RUN apt install wget

# Install Chrome 
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && DEBIAN_FRONTEND=noninteractive apt --yes install ./google-chrome-stable_current_amd64.deb
  
# Install Firefox
RUN DEBIAN_FRONTEND=noninteractive apt --yes install firefox

COPY token.sh /
RUN chmod +x /token.sh
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
