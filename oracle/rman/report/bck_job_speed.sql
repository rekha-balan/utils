-- The following query shows the backup job speed ordered by session key, 
-- which is the primary key for the RMAN session. 
-- The columns in_sec and out_sec display the data input and output per second
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967

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
