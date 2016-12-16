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

# Add certificates for HPE LDAPS
RUN mkdir -p /etc/pki/tls/certs
COPY hpca2ss_ns.pem /etc/pki/tls/certs/hpca2ss_ns.pem
COPY hpca2ssG2_ns.pem /etc/pki/tls/certs/hpca2ssG2_ns.pem
RUN cat /etc/pki/tls/certs/hpca2ss_ns.pem >> /etc/pki/tls/certs/ca-bundle.crt
RUN cat /etc/pki/tls/certs/hpca2ssG2_ns.pem >> /etc/pki/tls/certs/ca-bundle.crt
RUN keytool -v -import -noprompt -trustcacerts -alias hpca2ss -file /etc/pki/tls/certs/hpca2ss_ns.pem -keystore ${JAVA_HOME}/lib/security/cacerts -storepass changeit
RUN keytool -v -import -noprompt -trustcacerts -alias hpca2ssG2 -file /etc/pki/tls/certs/hpca2ssG2_ns.pem -keystore ${JAVA_HOME}/lib/security/cacerts -storepass changeit

# Configure LDAP
#ENV GERRIT_CONFIG ${GERRIT_SITE}/etc/gerrit.config
#RUN git config -f ${GERRIT_CONFIG} auth.type LDAP
#RUN git config -f ${GERRIT_CONFIG} auth.trustContainerAuth true
#RUN git config -f ${GERRIT_CONFIG} ldap.server ldaps://ldap.hp.com
#RUN git config -f ${GERRIT_CONFIG} ldap.accountBase ou=People,o=hp.com
#RUN git config -f ${GERRIT_CONFIG} ldap.accountPattern (&(objectClass=person)(mail=${username}))
#RUN git config -f ${GERRIT_CONFIG} ldap.accountSshUserName ${mail.localPart}
#RUN git config -f ${GERRIT_CONFIG} ldap.groupBase ou=Groups,o=hp.com
