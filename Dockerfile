FROM httpd:latest

RUN apt update && apt install -y \
	libapache2-mod-svn subversion-tools sudo vim \
	subversion --no-install-recommends &&\
	apt clean

RUN	mkdir -p /home/svn/repos &&\
    mkdir -p /run/apache2/ &&\
	mkdir -p /etc/subversion &&\
	touch /etc/subversion/passwd

COPY localuser.list /home/svn/localuser.list
COPY apache/ /etc/services.d/apache/
COPY subversion/ /etc/services.d/subversion/
COPY subversion-access-control /etc/subversion/subversion-access-control
RUN chmod a+w /etc/subversion/* && chmod a+w /home/svn

RUN cp /usr/lib/apache2/modules/mod_dav.so /usr/local/apache2/modules/ &&\
    cp /usr/lib/apache2/modules/mod_dav_svn.so /usr/local/apache2/modules/ &&\
    cp /usr/lib/apache2/modules/mod_authz_svn.so /usr/local/apache2/modules/

RUN sed -i s/'Listen 80'/'#Listen 80'/ /usr/local/apache2/conf/httpd.conf &&\
	sed -i -e '/#Listen 80$/a Listen 8080' /usr/local/apache2/conf/httpd.conf &&\
	echo 'Include conf/extra/svn.conf' >> /usr/local/apache2/conf/httpd.conf
COPY svn.conf /usr/local/apache2/conf/extra/

ARG USERNAME=subversion
ARG GROUPNAME=subversion
ARG UID=999
ARG GID=999
RUN groupadd -g $GID $GROUPNAME && \
    useradd -ml -s /bin/bash -u $UID -g $GID $USERNAME &&\
	echo "${USERNAME}:${USERNAME}" | sudo chpasswd
RUN echo "Defaults visiblepw"             >> /etc/sudoers
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chown -R $UID:$GID /etc/services.d/apache &&\
	chown -R $UID:$GID /etc/services.d/subversion &&\
	chown -R $UID:$GID /etc/subversion &&\
	chown -R $UID:$GID /home/svn &&\
	chown -R $UID:$GID /usr/local/apache2

USER $USERNAME

EXPOSE 8080 443 3690