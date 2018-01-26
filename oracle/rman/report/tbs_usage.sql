set lines 200
set pages 200
column value new_value dbblocksz noprint

select value from v$parameter where name = 'db_block_size';

select tablespace_name,
       used_space used_blocks,
       (used_space*&dbblocksz)/(1024*1024) used_mb,
       tablespace_size tablespace_blocks,
       (tablespace_size*&dbblocksz)/(1024*1024) tablespace_mb,
       used_percent
from dba_tablespace_usage_metrics;
