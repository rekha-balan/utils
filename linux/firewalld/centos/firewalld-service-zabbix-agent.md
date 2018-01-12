curl https://raw.githubusercontent.com/algrega/utils/master/linux/firewalld/centos/firewalld-service-zabbix-agent.xml -o /etc/firewalld/services/zabbix.xml
firewall-cmd --zone=public --permanent --add-service=zabbix
firewall-cmd --reload
firewall-cmd --list-all
