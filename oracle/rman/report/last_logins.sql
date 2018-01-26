set lines 200
col DB_SCHEMA for a30
col USER for a30
col HOST for a30
select 
  username as "DB_SCHEMA",
  os_username as "USER",
  userhost as "HOST"
  from dba_audit_session
  where TIMESTAMP > SYSDATE-7
  and username != 'ZABBIX'
  group by username, os_username, userhost;
exit
