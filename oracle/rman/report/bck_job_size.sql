-- The following query shows the backup job size and throughput ordered by session key, 
-- which is the primary key for the RMAN session. 
-- The columns in_size and out_size display the data input and output per second
-- http://docs.oracle.com/database/121/BRADV/rcmreprt.htm#BRADV99967

COL in_size  FORMAT a10
COL out_size FORMAT a10
SELECT SESSION_KEY, 
       INPUT_TYPE,
       COMPRESSION_RATIO, 
       INPUT_BYTES_DISPLAY in_size,
       OUTPUT_BYTES_DISPLAY out_size
FROM   V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;
