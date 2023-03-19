# Docker-vsftp-ldap

vsftpd in a container with LDAP (active directory) authentication.

I needed a container that would do FTP using active directory as its authentication.  These are the fruits of the effort.

This project is using confd as the method to steralize the configuration files and make it easy for me to dynamically adjust the configs without a full container rebuild. http://www.confd.io/

More details here: https://blog.jonathonharper.com/2019/10/25/ftp-docker-container-with-active-directory-authentication/

## Environment variables

```
- LDAP_BASE=dc=example,dc=org
- LDAP_BINDDN=cn=admin,dc=example,dc=org
- LDAP_BINDPW=<yourbindpw>
- LDAP_FILTER=(&(objectClass=posixAccount)(memberOf=cn=testgroup,ou=groups,dc=example,dc=org))
- LDAP_SSL_CACERTFILE=/etc/ssl/certs/ca-certificates.crt
- LDAP_SSL_ENABLE=off
- LDAP_URI=ldap://openldap:389
- VSFTPD_PASV_ENABLE=YES
- VSFTPD_PASV_MAX_PORT=10100
- VSFTPD_PASV_MIN_PORT=10105
- VSFTPD_SSL_CIPHERS=HIGH
- VSFTPD_SSL_ENABLE=NO
- VSFTPD_SSL_PRIVATEKEY=/etc/ssl/certs/privatekey.key
- VSFTPD_SSL_PUBLICKEY=/etc/ssl/certs/publickey.pem
- VSFTPD_SSL_SSLV2=NO
- VSFTPD_SSL_SSLV3=NO
- VSFTPD_SSL_TLSV1=YES
```