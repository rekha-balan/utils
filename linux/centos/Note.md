pro-fe-web1

yum install httpd mod_ssl php php-devel php-mysql php-pear gcc
systemctl enable httpd
systemctl stop firewalld
systemctl disable firewalld
rpm -Uvh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
rpm -Uvh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
pecl install oci8-2.0.12
echo extension=oci8.so > /etc/php.d/oci8.ini
systemctl restart httpd
realm join FQDNADDomain -v -U 'DomainAdminUsername' --computer-ou="OU=XXX,OU=XXX,DC=XXX,DC=XXX,DC=XX"
realm permit -g AdminADGroupName
realm permit -g DevADGroupName
echo "%AdminADGroupName ALL=(ALL) ALL" > /etc/sudoers.d/AdminADGroupName
echo "%DevADGroupName ALL=(ALL) ALL" > /etc/sudoers.d/DevADGroupName

Aggiungere disco per document root apache
reboot

ssm create --fs xfs -p data_pool -n Apache_Volume /dev/sdb /data
cd /etc/httpd/conf
mv httpd.conf httpd.conf.SAVE
curl -s https://raw.githubusercontent.com/algrega/utils/master/linux/centos/web/httpd.conf -o httpd.conf
mkdir -p /data/www/html
systemctl restart httpd

setfacl -m g:AdminADGroupName:rwx html
setfacl -m g: DevADGroupName:rwx html
setfacl -m d:g:AdminADGroupName:rw html
setfacl -m d:g: DevADGroupName:rw html