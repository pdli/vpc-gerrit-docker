FROM openfrontier/gerrit:2.12.6

# Add proxy
COPY .proxy /root/.proxy
RUN source /root/.proxy

# Change apk repository
COPY repositories /etc/apk/repositories

# Change gerrit shell
COPY change-gerrit-shell.sh /change-gerrit-shell.sh
RUN /change-gerrit-shell.sh

# Stablize ssh key and known hosts
RUN gosu ${GERRIT_USER} mkdir ${GERRIT_HOME}/.ssh
COPY id_rsa ${GERRIT_HOME}/.ssh/id_rsa
COPY known_hosts ${GERRIT_HOME}/.ssh/known_hosts
RUN chown ${GERRIT_USER}:${GERRIT_USER} ${GERRIT_HOME}/.ssh/id_rsa
RUN chown ${GERRIT_USER}:${GERRIT_USER} ${GERRIT_HOME}/.ssh/known_hosts

