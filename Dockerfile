FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install -y \
gawk \
iproute2 \
libpam-ldapd \
vsftpd \
 && rm -rf /var/lib/apt/lists/*

ENV PASV_ADDRESS **IPv4**
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077

COPY confd-0.16.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

COPY etc/ /etc/
COPY sbin/ /sbin/

RUN chmod +x /sbin/init.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/
# Fix vsftpd: not found: directory given in 'secure_chroot_dir':/var/run/vsftpd/empty
RUN mkdir -p /var/run/vsftpd/empty

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

EXPOSE 20 21 10100-10105

CMD [ "/sbin/init.sh" ]
