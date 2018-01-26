-- The following query shows the backup job history ordered by session key, 
-- which is the primary key for the RMAN session
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967

COL STATUS FORMAT a9
COL hrs    FORMAT 999.99
SELECT SESSION_KEY, INPUT_TYPE, STATUS,
       TO_CHAR(START_TIME,'mm/dd/yy hh24:mi') start_time,
       TO_CHAR(END_TIME,'mm/dd/yy hh24:mi')   end_time,
       ELAPSED_SECONDS/3600                   hrs
FROM V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;
