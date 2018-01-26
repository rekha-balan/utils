-- The following query shows the backup job history ordered by session key, 
-- which is the primary key for the RMAN session
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967
set feedback off
set pagesize 10000
prompt
prompt BACKUP HISTORY
prompt ##############
COL STATUS FORMAT a9
COL hrs    FORMAT 999.99
SELECT SESSION_KEY, INPUT_TYPE, STATUS,
       TO_CHAR(START_TIME,'mm/dd/yy hh24:mi') start_time,
       TO_CHAR(END_TIME,'mm/dd/yy hh24:mi')   end_time,
       ELAPSED_SECONDS/3600                   hrs
FROM V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;

-- The following query shows the backup job size and throughput ordered by session key, 
-- which is the primary key for the RMAN session. 
-- The columns in_size and out_size display the data input and output per second
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967
prompt
prompt BACKUP SIZE AND THROUGHPUT
prompt ##########################
COL in_size  FORMAT a10
COL out_size FORMAT a10
SELECT SESSION_KEY, 
       INPUT_TYPE,
       COMPRESSION_RATIO, 
       INPUT_BYTES_DISPLAY in_size,
       OUTPUT_BYTES_DISPLAY out_size
FROM   V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;

-- The following query shows the backup job speed ordered by session key, 
-- which is the primary key for the RMAN session. 
-- The columns in_sec and out_sec display the data input and output per second
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967
prompt
prompt BACKUP SPEED
prompt ############
COL in_sec FORMAT a10
COL out_sec FORMAT a10
COL TIME_TAKEN_DISPLAY FORMAT a10
SELECT SESSION_KEY, 
       OPTIMIZED, 
       COMPRESSION_RATIO, 
       INPUT_BYTES_PER_SEC_DISPLAY in_sec,
       OUTPUT_BYTES_PER_SEC_DISPLAY out_sec, 
       TIME_TAKEN_DISPLAY
FROM   V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;
