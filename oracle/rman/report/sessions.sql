set lines 200
col machine for a35
col program for a50
col username for a20
col logon_time for a30
col status for a20
select username,sid,serial#,machine,TO_CHAR(logon_time,'DD-MON-YYYY HH24:MI:SS')logon_time,program,status from v$session where username is not null order by logon_time;
