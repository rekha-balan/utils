col OPNAME for a30
select OPNAME,SOFAR/TOTALWORK*100 PCT, trunc(TIME_REMAINING/60) MIN_REMAINING,
trunc(ELAPSED_SECONDS/60) MIN_ELAPSED
from v$session_longops where TOTALWORK>0 and OPNAME like '%RMAN%';