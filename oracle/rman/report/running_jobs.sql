set feedback off
alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';
set lines 200
set feedback on
col username for a30
select
   jr.job,
   s.username,
   s.sid,
   s.serial#,
   p.spid,
   s.lockwait,
   s.logon_time
from
   dba_jobs_running jr,
   v$session s,
   v$process p
where
   jr.sid = s.sid
and
   s.paddr = p.addr
order by
   jr.job
;
