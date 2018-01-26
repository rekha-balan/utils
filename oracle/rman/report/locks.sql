set lines 200
set pages 200
col program_holding for a30
col program_waiting for a30
col machine for a30
col username for a10
col status for a20
col logon_time for a20

SELECT vs.username username,
 vs.machine,
 vs.logon_time,
 vh.sid locking_sid,
 vs.serial# serial,
 vs.status status,
 vs.program program_holding,
 vw.sid waiter_sid,
 vsw.program program_waiting
FROM v$lock vh,
 v$lock vw,
 v$session vs,
 v$session vsw
WHERE     (vh.id1, vh.id2) IN (SELECT id1, id2
 FROM v$lock
 WHERE request = 0
 INTERSECT
 SELECT id1, id2
 FROM v$lock
 WHERE lmode = 0)
 AND vh.id1 = vw.id1
 AND vh.id2 = vw.id2
 AND vh.request = 0
 AND vw.lmode = 0
 AND vh.sid = vs.sid
 AND vw.sid = vsw.sid;
