FROM node:6

ADD bin/kubectl-1.4.5 /usr/bin/kubectl
RUN chmod a+x /usr/bin/kubectl

ADD bin/helm-2.0.0-beta.2 /usr/bin/helm
RUN chmod a+x /usr/bin/helm

RUN npm install -g phantomjs
