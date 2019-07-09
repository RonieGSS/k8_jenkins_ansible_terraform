FROM jenkins/jenkins:lts

LABEL maintainer = "Ronie Vincent Horca <ronievincent.gss@gmail.com>"
USER root:root
RUN apt-get update && \
	apt-get -y install apt-transport-https \
	     ca-certificates \
	     curl \
	     gnupg2 \
	     software-properties-common && \
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
	   $(lsb_release -cs) \
	   stable" && \
	curl -sL https://deb.nodesource.com/setup_10.x | bash -E - && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	touch /etc/apt/sources.list.d/kubernetes.list && \
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
	apt-get update && \
	apt-get -y install docker-ce \
	nodejs \
	build-essential \
	npm \
	gettext \
	kubectl && \
	npm install --global webpack -D webpack-cli && \
	npm link webpack