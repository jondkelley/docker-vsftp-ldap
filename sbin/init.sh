#! /bin/bash

# set -x

# Set passive mode parameters:
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
    export PASV_ADDRESS=$(ip route|awk '/default/ { print $3 }')
fi

# Generate dynamic configs from environment variables
confd -onetime -backend env

echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd.conf
echo "file_open_mode=${FILE_OPEN_MODE}" >> /etc/vsftpd.conf
echo "local_umask=${LOCAL_UMASK}" >> /etc/vsftpd.conf

# Set permission required for nslcd
chmod 400 /etc/nslcd.conf

# Restart nslcd service, needed to pull in ldap users for some reason.
service nslcd restart

# Run vsftpd:
/usr/sbin/vsftpd /etc/vsftpd.conf